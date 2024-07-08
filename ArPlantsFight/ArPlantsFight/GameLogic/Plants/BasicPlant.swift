//
//  BasicPlant.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 26.06.24.
//

import Foundation
import RealityKit

@Observable
class BasicPlant: Plant {
    required init() {
        super.init(liveAmount: 100, expense: 50, pace: 0.8, projectileMovementSpeed: 0.5, dmgAmountProjectile: 20)
    }
    
    override func createPlant(widthIndex: Int, lenghtIndex: Int) -> ModelEntity? {
        let modelName = "BasePlant"
        return super.createPlant(modelName: modelName, widthIndex: widthIndex, lenghtIndex: lenghtIndex)
    }
}
