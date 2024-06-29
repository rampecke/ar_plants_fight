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
    var movingPace: Double
    var dmgAmountHit: Int
    var startedMoving: Bool = false
    
    var zombieEntity: Entity = Entity()
    
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
    
    func createZombie(modelName: String) -> Entity? {
        // Load the USDZ model
        guard let modelEntity = try? ModelEntity.load(named: modelName) else {
            print("Failed to load model")
            return nil
        }
        
        self.zombieEntity = modelEntity
        
        return modelEntity
    }
    
    func createZombie() -> Entity? {
        fatalError("This class cannot create a plant directly")
    }
}
