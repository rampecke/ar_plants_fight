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
    //A Buckethad zombie has 100 live and each hit every 2 seconds makes 25 damage, he moves at a pace of 4.0 per square
    required init() {
        let duration: TimeInterval = 4.0
        super.init(liveAmount: 100, movingPace: duration, dmgAmountHit: 25, hittingPace: 2.0)
    }
    
    override func createZombie(modelLoader: ModelLoader) -> ModelEntity? {
        return super.createZombie(zombie: modelLoader.returnCopyOf(zombieType: .BucketHeadZombie))
    }
}
