//
//  Zombie.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 28.06.24.
//

import Foundation
import RealityKit

@Observable
class Zombie {
    var liveAmount: Int
    var movingPace: TimeInterval
    var dmgAmountHit: Int
    var startedMoving: Bool = false
    
    var zombieEntity: ModelEntity = ModelEntity()
    
    // Internal initializer to prevent instantiation of Plant directly
    init(liveAmount: Int, movingPace: TimeInterval, dmgAmountHit: Int) {
        self.liveAmount = liveAmount
        self.movingPace = movingPace
        self.dmgAmountHit = dmgAmountHit
    }
    
    // Required initializer to ensure subclasses implement their own initializers
    required init() {
        fatalError("This class cannot be instantiated directly")
    }
    
    func createZombie(zombie: ModelEntity?) -> ModelEntity? {
        // Load the USDZ model
        guard let modelEntity = zombie else {
            print("Failed to load model")
            return nil
        }
        
        // Get the bounding box of the model
        let boundingBox = modelEntity.visualBounds(relativeTo: nil)
        let zombieWidth = boundingBox.extents.x
        let zombieHeight = boundingBox.extents.y
        let zombieDepth = boundingBox.extents.z

        // Create a CollisionComponent and add it to the model entity
        let collisionComponent = CollisionComponent(shapes: [.generateBox(size: [zombieWidth, zombieHeight, zombieDepth])],
                                                    mode: .default,
                                                    filter: CollisionFilter(group: CollisionGroups.zombie, mask: .all))
        modelEntity.collision = collisionComponent
        
        self.zombieEntity = modelEntity
        
        return modelEntity
    }
    
    func createZombie(modelLoader: ModelLoader) -> Entity? {
        fatalError("This class cannot create a plant directly")
    }
}
