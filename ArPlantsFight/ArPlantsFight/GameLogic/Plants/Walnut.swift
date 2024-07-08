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
    
    override func createPlant(widthIndex: Int, lenghtIndex: Int) -> ModelEntity? {
        return nil
    }
    
    override func shootProjectiles(viewModel: ArViewModel) {
        //does not shoot
    }
}
