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
        let duration: TimeInterval = 35.0
        super.init(liveAmount: 100, movingPace: duration, dmgAmountHit: 25)
    }
    
    override func createZombie() -> Entity? {
        let modelName = "ZombieBucketHead"
        return super.createZombie(modelName: modelName)
    }
}
