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
        super.init(liveAmount: 100, expense: 50, pace: 1.0, projectileMovementSpeed: 5.0, dmgAmountProjectile: 20)
    }
    
    override func createPlant(widthIndex: Int, lenghtIndex: Int) -> Entity? {
        let modelName = "BasePlant"
        return super.createPlant(modelName: modelName, widthIndex: widthIndex, lenghtIndex: lenghtIndex)
    }
}
