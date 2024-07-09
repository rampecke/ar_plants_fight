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
    private var moneyTimer: Timer?
    
    required init() {
        super.init(liveAmount: 50, expense: 50, pace: 10.0, projectileMovementSpeed: 0, dmgAmountProjectile: 50)
    }
    
    override func createPlant(modelLoader: ModelLoader, widthIndex: Int, lenghtIndex: Int) -> ModelEntity? {
        return super.createPlant(plant: modelLoader.returnCopyOf(plantType: .Sunflower) ?? nil, widthIndex: widthIndex, lenghtIndex: lenghtIndex)
    }
    
    override func plantDescription() -> String {
        return "Live: \(liveAmount), Expense: \(expense), Special Ability: Generates every \(roundedString(for: pace)) \(dmgAmountProjectile) amount of money"
    }
    
    override func shootProjectiles(viewModel: ArViewModel) {
        self.timer = Timer.scheduledTimer(withTimeInterval: pace, repeats: shooting) { _ in
            viewModel.money = viewModel.money + self.dmgAmountProjectile
            
            let textMesh = MeshResource.generateText(
                "+\(self.dmgAmountProjectile)",
                extrusionDepth: 0.01,
                font: .systemFont(ofSize: 0.03),
                containerFrame: .zero,
                alignment: .left,
                lineBreakMode: .byWordWrapping
            )
            let textMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
            let textModel = ModelEntity(mesh: textMesh, materials: [textMaterial])
            textModel.position = [self.plantEntity.position.x, self.plantEntity.position.y + 0.1, self.plantEntity.position.z ]
            viewModel.worldEntity.addChild(textModel)
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                viewModel.worldEntity.removeChild(textModel)
            }
        }
    }
    
    deinit {
        moneyTimer?.invalidate()
    }
}
