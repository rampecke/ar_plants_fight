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
    
    var zombieEntities: [[Zombie]] = []
    var plantEntities: [[Plant?]] = []
    
    init(width: Int, length: Int) {
        self.width = width
        self.length = length
        
        for _ in 0..<length {
            zombieEntities.append([])
        }
        
        for i in 0..<length {
            plantEntities.append([])
            for _ in 0..<width {
                plantEntities[i].append(nil)
            }
        }
        
        addPlantToPosition(widthIndex: 0, lenghtIndex: 0, plant: Sunflower())
        addPlantToPosition(widthIndex: 0, lenghtIndex: 1, plant: Sunflower())
        addPlantToPosition(widthIndex: 0, lenghtIndex: 2, plant: BasicPlant())
        addPlantToPosition(widthIndex: 0, lenghtIndex: 3, plant: Sunflower())
        addPlantToPosition(widthIndex: 0, lenghtIndex: 4, plant: BasicPlant())
        
        spawnZombieAtLane(laneNumber: 0, zombie: BucketHeadZombie())
        spawnZombieAtLane(laneNumber: 1, zombie: BucketHeadZombie())
        spawnZombieAtLane(laneNumber: 2, zombie: BucketHeadZombie())
        spawnZombieAtLane(laneNumber: 3, zombie: BucketHeadZombie())
        spawnZombieAtLane(laneNumber: 4, zombie: BucketHeadZombie())
    }
    
    func moveZombies() {
        for (laneNumber, lane) in zombieEntities.enumerated() {
            lane.forEach {
                if !$0.startedMoving {
                    let zombieEntity = $0.zombieEntity
                    zombieEntity.move(to: Transform(
                        scale: zombieEntity.transform.scale,
                        rotation: zombieEntity.transform.rotation,
                        translation: [0, tileHeight, tileWidth * Float(laneNumber)]
                    ), relativeTo: worldEntity, duration: $0.movingPace)
                    $0.startedMoving = true
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
    
    //AR Functions
    private func createArWorld() {
        let floorTileMesh = MeshResource.generateBox(width: tileWidth, height: tileHeight, depth: tileWidth)
        
        for i in 0...width-1 {
            for j in 0...length-1 {
                let entity = ModelEntity(mesh: floorTileMesh, materials: [getColorFloorTile(widthIndex: i, lenghtIndex: j)])
                entity.position = [tileWidth*Float(i),0,tileWidth*Float(j)]
                worldEntity.addChild(entity)
            }
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
        //TODO: Check if the position exists
        guard let modelEntity = plant.createPlant() else {
            print("Failed to create plant")
            return
        }
        
        plantEntities[lenghtIndex][widthIndex] = plant
        
        modelEntity.position = [tileWidth*Float(widthIndex),0+tileHeight,tileWidth*Float(lenghtIndex)]
        worldEntity.addChild(modelEntity)
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
    
    func anchorWorld(arView: ARView, anchor: AnchorEntity) {
        if(!arWorldWasCreated) {
            createArWorld()
            arWorldWasCreated = true
        }
        //Reposition because of Offset
        worldEntity.position = [-(tileWidth * Float(width)/2), 0, -(tileWidth * Float(length)/2)]
        anchor.addChild(self.worldEntity)
        arView.scene.addAnchor(anchor)
    }
}

enum ArMode {
    case AR
    case NonAR
}
