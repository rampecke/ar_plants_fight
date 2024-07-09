//
//  ArViewModel.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 17.06.24.
//

import Foundation
import RealityKit

@Observable
class ArViewModel {
    let tileHeight: Float = 0.001
    let tileWidth: Float =  0.08
    var width: Int
    var length: Int
    
    var worldEntity: Entity = Entity()
    private var arWorldWasCreated: Bool = false
    var worldEntityWasAnchored: Bool = false
    
    var zombieEntities: [[Zombie]] = []
    var plantEntities: [[Plant?]] = []
    var projectiles: [[Entity]] = []
    var floorTiles: [[Entity]] = []
    
    var selectedPlant: PlantTypes = PlantTypes.BasicPlant
    var modelLoader: ModelLoader = ModelLoader()
    
    var money: Int = 0
    private var moneyTimer: Timer?
    
    init(width: Int, length: Int) {
        self.width = width
        self.length = length
        
        for _ in 0..<length {
            zombieEntities.append([])
            self.projectiles.append([])
        }
        
        for i in 0..<length {
            plantEntities.append([])
            for _ in 0..<width {
                plantEntities[i].append(nil)
            }
        }
    }
    
    func startMoneyIncrement() {
        let textMesh = MeshResource.generateText(
            "Money: \(money)",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.05),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byWordWrapping
        )
        let textMaterial = SimpleMaterial(color: .black, isMetallic: false)
        let textModel = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textModel.position = [0,0,-0.1]
        worldEntity.addChild(textModel)
        
        moneyTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            self.money += 1
            let textMesh = MeshResource.generateText(
                "Money: \(self.money)",
                extrusionDepth: 0.01,
                font: .systemFont(ofSize: 0.05),
                containerFrame: .zero,
                alignment: .left,
                lineBreakMode: .byWordWrapping
            )
            textModel.model?.mesh = textMesh
        }
    }
        
    deinit {
        moneyTimer?.invalidate()
    }
    
    func updateView() {
        if self.worldEntityWasAnchored {
            moveZombies()
            shootPlants()
        }
    }
    
    func removeEntityFromProjectiles(projectileEntity: ModelEntity, zombieEntity: ModelEntity, viewModel: ArViewModel) {
        for i in 0..<projectiles.count {
            if let index = projectiles[i].firstIndex(of: projectileEntity) {
                projectiles[i].remove(at: index)
                break
            }
        }
        
        if let parent = projectileEntity.parent, parent == viewModel.worldEntity {
            Task {
                await viewModel.worldEntity.removeChild(projectileEntity)
            }
        } else {
            print("projectileEntity has no parent or not the expected parent, cannot remove")
        }
        
        for i in 0..<zombieEntities.count {
            if let index = zombieEntities[i].firstIndex(where: {$0.zombieEntity == zombieEntity}) {
                let zombie = zombieEntities[i][index]
                zombie.liveAmount = zombie.liveAmount - 25
                if (zombie.liveAmount <= 0) {
                    zombie.timer?.invalidate()
                    zombieEntities[i].remove(at: index)
                    Task {
                        await viewModel.worldEntity.removeChild(zombieEntity)
                    }
                }
            }
        }
    }
    
    func zombieHitPlant(zombieEntity: ModelEntity, plantEntity: ModelEntity, viewModel: ArViewModel) {
        let currentPosition = zombieEntity.position
        zombieEntity.stopAllAnimations()
        zombieEntity.position = currentPosition
        
        for i in 0..<zombieEntities.count {
            if let index = zombieEntities[i].firstIndex(where: {$0.zombieEntity == zombieEntity}) {
                let zombie = zombieEntities[i][index]
                
                if let plantIndex = viewModel.plantEntities[i].firstIndex(where: { $0?.plantEntity == plantEntity }) {
                    guard let plant = viewModel.plantEntities[i][plantIndex] else {return}
                    
                    var goIntoLoop = plant.liveAmount > 0
                    
                    zombie.timer = Timer.scheduledTimer(withTimeInterval: zombie.hittingPace, repeats: goIntoLoop) { _ in
                        plant.liveAmount = plant.liveAmount - zombie.dmgAmountHit
                        if plant.liveAmount <= 0 {
                            viewModel.plantEntities[i][plantIndex] = nil
                            viewModel.worldEntity.removeChild(plantEntity)
                            plant.shooting = false
                            goIntoLoop = false
                            plant.timer?.invalidate()
                            
                            let duration = (Double(plant.position.0)) * zombie.movingPace
                            zombieEntity.move(to: Transform(
                                scale: zombieEntity.transform.scale,
                                rotation: zombieEntity.transform.rotation,
                                translation: [0, self.tileHeight, self.tileWidth * Float(i)]
                            ), relativeTo: self.worldEntity, duration: duration, timingFunction: .linear)
                        }
                    }
                }
            }
        }
    }
    
    private func moveZombies() {
        for (laneNumber, lane) in zombieEntities.enumerated() {
            lane.forEach {
                if !$0.startedMoving {
                    let zombieEntity = $0.zombieEntity
                    $0.startedMoving = true
                    let duration = (Double(self.width)) * $0.movingPace
                    zombieEntity.move(to: Transform(
                        scale: zombieEntity.transform.scale,
                        rotation: zombieEntity.transform.rotation,
                        translation: [0, tileHeight, tileWidth * Float(laneNumber)]
                    ), relativeTo: worldEntity, duration: duration, timingFunction: .linear)
                }
            }
        }
    }
    
    private func shootPlants() {
        plantEntities.forEach {
            $0.forEach { plant in
                if let plant = plant {
                    if !plant.shooting {
                        plant.shooting = true
                        plant.shootProjectiles(viewModel: self)
                    }
                }
            }
        }
    }
    
    func anchorWorld(arView: ARView, anchor: AnchorEntity) {
        if(!arWorldWasCreated) {
            createArWorld()
            arWorldWasCreated = true
            //Reposition because of Offset
            worldEntity.position = [-(tileWidth * Float(width)/2), 0, -(tileWidth * Float(length)/2)]
        }
        anchor.addChild(self.worldEntity)
        arView.scene.addAnchor(anchor)
        self.worldEntityWasAnchored = true
        
        startMoneyIncrement()
    }
    
    //AR Functions
    private func createArWorld() {
        let floorTileMesh = MeshResource.generateBox(width: tileWidth, height: tileHeight, depth: tileWidth)
        
        for i in 0...width-1 {
            var row: [Entity] = []
            for j in 0...length-1 {
                let entity = ModelEntity(mesh: floorTileMesh, materials: [getColorFloorTile(widthIndex: i, lenghtIndex: j)])
                entity.position = [tileWidth*Float(i),0,tileWidth*Float(j)]
                entity.collision = CollisionComponent(shapes: [.generateBox(size: [tileWidth, tileHeight, tileWidth])],
                                                          mode: .default,
                                                          filter: CollisionFilter(group: CollisionGroups.tile, mask: [.all]))
                
                worldEntity.addChild(entity)
                row.append(entity)
            }
            floorTiles.append(row)
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.spawnZombieAtLane(laneNumber: 1, zombie: BucketHeadZombie())
        }
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
            self.spawnZombieAtLane(laneNumber: 3, zombie: BucketHeadZombie())
        }
        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { _ in
            self.spawnZombieAtLane(laneNumber: 3, zombie: BucketHeadZombie())
        }
        
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { _ in
            self.spawnZombieAtLane(laneNumber: 3, zombie: BucketHeadZombie())
        }

        //spawnZombieAtLane(laneNumber: 0, zombie: BucketHeadZombie())
        //spawnZombieAtLane(laneNumber: 1, zombie: BucketHeadZombie())
        //spawnZombieAtLane(laneNumber: 2, zombie: BucketHeadZombie())
        //spawnZombieAtLane(laneNumber: 3, zombie: BucketHeadZombie())
        //spawnZombieAtLane(laneNumber: 4, zombie: BucketHeadZombie())
    }
    
    
    private func getColorFloorTile(widthIndex: Int, lenghtIndex: Int) -> SimpleMaterial {
        let floorTileMaterial = SimpleMaterial(color: SimpleMaterial.Color(named: "gras_dark") ?? .gray, roughness: 0.5, isMetallic: true)
        let floorTileMaterial2 = SimpleMaterial(color: SimpleMaterial.Color(named: "gras_light") ?? .green, roughness: 0.5, isMetallic: true)
        
        if widthIndex % 2 == 0 {
            if lenghtIndex % 2 == 0 {
              return floorTileMaterial
            } else {
                return floorTileMaterial2
            }
        } else {
            if lenghtIndex % 2 == 0 {
                return floorTileMaterial2
            } else {
                return floorTileMaterial
            }
        }
    }
    
    func addPlantToPosition(widthIndex: Int, lenghtIndex: Int, plant: Plant) {
        if money >= plant.expense {
            if lenghtIndex >= plantEntities.count || widthIndex >= plantEntities[lenghtIndex].count {
                return
            }
            
            if plantEntities[lenghtIndex][widthIndex] == nil {
                guard let modelEntity = plant.createPlant(modelLoader: self.modelLoader, widthIndex: widthIndex, lenghtIndex: lenghtIndex) else {
                    print("Failed to create plant")
                    return
                }
                
                plantEntities[lenghtIndex][widthIndex] = plant
                
                modelEntity.position = [tileWidth*Float(widthIndex),0+tileHeight,tileWidth*Float(lenghtIndex)]
                worldEntity.addChild(modelEntity)
                money = money - plant.expense
            }
        }
    }
    
    func handleTileTap(hitEntity: Entity) {
        for i in 0..<width {
            for j in 0..<length {
                if floorTiles[i][j] == hitEntity {
                    addPlantToPosition(widthIndex: i, lenghtIndex: j, plant: selectedPlant == .Sunflower ? Sunflower() : selectedPlant == .Walnut ? Walnut() : BasicPlant())
                }
            }
        }
    }
    
    func spawnZombieAtLane(laneNumber: Int, zombie: Zombie) {
        if zombieEntities.count <= laneNumber {
            return
        }
        
        guard let modelEntity = zombie.createZombie(modelLoader: self.modelLoader) else {
            print("Failed to spawn zombie")
            return
        }
        
        zombieEntities[laneNumber].append(zombie)
        
        modelEntity.position = [tileWidth*Float(self.width),0+tileHeight,tileWidth*Float(laneNumber)]
        modelEntity.transform.rotation = simd_quatf(angle: Float.pi / 2, axis: SIMD3<Float>(0, 1, 0))
        worldEntity.addChild(modelEntity)
    }
}

enum PlantTypes {
    case Sunflower
    case Walnut
    case BasicPlant
}

enum ZombieTypes {
    case BucketHeadZombie
}
