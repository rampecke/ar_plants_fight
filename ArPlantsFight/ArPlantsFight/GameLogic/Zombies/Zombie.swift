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
    var hittingPace: TimeInterval
    var startedMoving: Bool = false
    
    var zombieEntity: ModelEntity = ModelEntity()
    var timer: Timer?
    
    // Internal initializer to prevent instantiation of Plant directly
    init(liveAmount: Int, movingPace: TimeInterval, dmgAmountHit: Int, hittingPace: TimeInterval) {
        self.liveAmount = liveAmount
        self.movingPace = movingPace
        self.dmgAmountHit = dmgAmountHit
        self.hittingPace = hittingPace
    }
    
    deinit {
        timer?.invalidate()
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

        // Create a CollisionComponent and add it to the model entity
        let collisionComponent = CollisionComponent(shapes: [.generateBox(size: [50, 200, 50])],
                                                    mode: .default,
                                                    filter: CollisionFilter(group: CollisionGroups.zombie, mask: .all))
        modelEntity.collision = collisionComponent
        
        self.zombieEntity = modelEntity
        
        return modelEntity
    }
    
    func createZombie(modelLoader: ModelLoader) -> ModelEntity? {
        fatalError("This class cannot create a plant directly")
    }
}
