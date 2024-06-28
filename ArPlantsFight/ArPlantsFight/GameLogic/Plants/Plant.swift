//
//  Plant.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 26.06.24.
//

import Foundation
import RealityKit

class Plant {
    var liveAmount: Int
    var expense: Int
    var pace: Double
    var dmgAmountProjectile: Int
    
    // Internal initializer to prevent instantiation of Plant directly
    init(liveAmount: Int, expense: Int, pace: Double, dmgAmountProjectile: Int) {
        self.liveAmount = liveAmount
        self.expense = expense
        self.pace = pace
        self.dmgAmountProjectile = dmgAmountProjectile
    }
    
    // Required initializer to ensure subclasses implement their own initializers
    required init() {
        fatalError("This class cannot be instantiated directly")
    }
    
    func createPlant(modelName: String) -> Entity? {
        // Load the USDZ model
        guard let modelEntity = try? ModelEntity.load(named: modelName) else {
            print("Failed to load model")
            return nil
        }
        
        return modelEntity
    }
    
    func createPlant() -> Entity? {
        fatalError("This class cannot create a plant directly")
    }
}
