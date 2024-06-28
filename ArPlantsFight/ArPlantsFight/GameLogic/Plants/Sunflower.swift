//
//  Sunflower.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 26.06.24.
//

import Foundation
import RealityKit

class Sunflower: Plant {
    required init() {
        super.init(liveAmount: 50, expense: 50, pace: 0, dmgAmountProjectile: 0)
    }
    
    override func createPlant() -> Entity? {
        let modelName = "Sunflower"
        return super.createPlant(modelName: modelName)
    }
}
