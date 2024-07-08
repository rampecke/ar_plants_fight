//
//  Sunflower.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 26.06.24.
//

import Foundation
import RealityKit

@Observable
class Sunflower: Plant {
    required init() {
        super.init(liveAmount: 50, expense: 50, pace: 0, projectileMovementSpeed: 0, dmgAmountProjectile: 0)
    }
    
    override func createPlant(widthIndex: Int, lenghtIndex: Int) -> ModelEntity? {
        let modelName = "Sunflower"
        return super.createPlant(modelName: modelName, widthIndex: widthIndex, lenghtIndex: lenghtIndex)
    }
    
    override func shootProjectiles(viewModel: ArViewModel) {
        //TODO: Add money instead
    }
}
