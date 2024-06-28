//
//  BasicPlant.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 26.06.24.
//

import Foundation
import Combine
import RealityKit

class BasicPlant: Plant {
    required init() {
        super.init(liveAmount: 100, expense: 50, pace: 1.0, dmgAmountProjectile: 20)
    }
    
    override func createPlant() -> Entity? {
        let modelName = "BasePlant"
        return super.createPlant(modelName: modelName)
    }
}
