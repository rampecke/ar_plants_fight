//
//  BucketHeadZombie.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 28.06.24.
//

import Foundation
import RealityKit

@Observable
class BucketHeadZombie: Zombie{
    required init() {
        let duration: TimeInterval = 5.0
        super.init(liveAmount: 100, movingPace: duration, dmgAmountHit: 25, hittingPace: 2.0)
    }
    
    override func createZombie(modelLoader: ModelLoader) -> ModelEntity? {
        return super.createZombie(zombie: modelLoader.returnCopyOf(zombieType: .BucketHeadZombie))
    }
}
