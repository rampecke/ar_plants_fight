//
//  Walnut.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 26.06.24.
//

import Foundation
import RealityKit

@Observable
class Walnut: Plant {
    required init() {
        super.init(liveAmount: 300, expense: 100, pace: 0, projectileMovementSpeed: 0, dmgAmountProjectile: 0)
    }
    
    override func createPlant(modelLoader: ModelLoader, widthIndex: Int, lenghtIndex: Int) -> ModelEntity? {
        return super.createPlant(plant: modelLoader.returnCopyOf(plantType: .Walnut) ?? nil, widthIndex: widthIndex, lenghtIndex: lenghtIndex)
    }
    
    override func shootProjectiles(viewModel: ArViewModel) {
        //does not shoot
    }
}
