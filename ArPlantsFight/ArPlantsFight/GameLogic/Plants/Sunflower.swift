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
    
    override func createPlant(modelLoader: ModelLoader, widthIndex: Int, lenghtIndex: Int) -> ModelEntity? {
        return super.createPlant(plant: modelLoader.returnCopyOf(plantType: .Sunflower) ?? nil, widthIndex: widthIndex, lenghtIndex: lenghtIndex)
    }
    
    override func shootProjectiles(viewModel: ArViewModel) {
        //TODO: Add money instead
    }
}
