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
    var arMode: ArMode = .AR
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
        
        spawnZombieAtLane(laneNumber: 0, zombie: BucketHeadZombie())
        spawnZombieAtLane(laneNumber: 1, zombie: BucketHeadZombie())
        spawnZombieAtLane(laneNumber: 2, zombie: BucketHeadZombie())
        spawnZombieAtLane(laneNumber: 3, zombie: BucketHeadZombie())
        spawnZombieAtLane(laneNumber: 4, zombie: BucketHeadZombie())
    }
    
    func updateView() {
        if self.worldEntityWasAnchored {
            moveZombies()
            shootPlants()
        }
    }
    
    private func moveZombies() {
        for (laneNumber, lane) in zombieEntities.enumerated() {
            lane.forEach {
                if !$0.startedMoving {
                    let zombieEntity = $0.zombieEntity
                    $0.startedMoving = true
                    zombieEntity.move(to: Transform(
                        scale: zombieEntity.transform.scale,
                        rotation: zombieEntity.transform.rotation,
                        translation: [0, tileHeight, tileWidth * Float(laneNumber)]
                    ), relativeTo: worldEntity, duration: $0.movingPace, timingFunction: .linear)
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
    
    func toggleArMode() {
        if(arMode == .AR) {
            arMode = .NonAR
        } else {
            arMode = .AR
        }
    }
    
    func anchorWorld(arView: ARView, anchor: AnchorEntity) {
        if(!arWorldWasCreated) {
            createArWorld()
            arWorldWasCreated = true
            //Reposition because of Offset
            //worldEntity.position = [-(tileWidth * Float(width)/2), 0, -(tileWidth * Float(length)/2)]
        }
        anchor.addChild(self.worldEntity)
        arView.scene.addAnchor(anchor)
        self.worldEntityWasAnchored = true
    }
    
    //AR Functions
    private func createArWorld() {
        let floorTileMesh = MeshResource.generateBox(width: tileWidth, height: tileHeight, depth: tileWidth)
        
        for i in 0...width-1 {
            var row: [Entity] = []
            for j in 0...length-1 {
                let entity = ModelEntity(mesh: floorTileMesh, materials: [getColorFloorTile(widthIndex: i, lenghtIndex: j)])
                entity.position = [tileWidth*Float(i),0,tileWidth*Float(j)]
                
                entity.components[CollisionComponent.self] = CollisionComponent(shapes: [ShapeResource.generateBox(width: tileWidth, height: tileHeight, depth: tileWidth)])
                
                worldEntity.addChild(entity)
                row.append(entity)
            }
            floorTiles.append(row)
        }
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
        if lenghtIndex >= plantEntities.count || widthIndex >= plantEntities[lenghtIndex].count {
            return
        }
        
        if plantEntities[lenghtIndex][widthIndex] == nil {
            guard let modelEntity = plant.createPlant(widthIndex: widthIndex, lenghtIndex: lenghtIndex) else {
                print("Failed to create plant")
                return
            }
            
            plantEntities[lenghtIndex][widthIndex] = plant
            
            modelEntity.position = [tileWidth*Float(widthIndex),0+tileHeight,tileWidth*Float(lenghtIndex)]
            worldEntity.addChild(modelEntity)
        }
    }
    
    func handleTileTap(hitEntity: Entity) {
        for i in 0..<width {
            for j in 0..<length {
                if floorTiles[i][j] == hitEntity {
                    addPlantToPosition(widthIndex: i, lenghtIndex: j, plant: BasicPlant())
                }
            }
        }
    }
    
    func spawnZombieAtLane(laneNumber: Int, zombie: Zombie) {
        //TODO: Check if the laneNumber exists
        
        guard let modelEntity = zombie.createZombie() else {
            print("Failed to spawn zombie")
            return
        }
        
        zombieEntities[laneNumber].append(zombie)
        
        modelEntity.position = [tileWidth*Float(self.width),0+tileHeight,tileWidth*Float(laneNumber)]
        modelEntity.transform.rotation = simd_quatf(angle: Float.pi / 2, axis: SIMD3<Float>(0, 1, 0))
        worldEntity.addChild(modelEntity)
    }
}

enum ArMode {
    case AR
    case NonAR
}
