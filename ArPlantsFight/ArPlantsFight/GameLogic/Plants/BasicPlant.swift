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
    
    override func createPlant(modelLoader: ModelLoader, widthIndex: Int, lenghtIndex: Int) -> ModelEntity? {
        return super.createPlant(plant: modelLoader.returnCopyOf(plantType: .BasicPlant) ?? nil, widthIndex: widthIndex, lenghtIndex: lenghtIndex)
    }
}
