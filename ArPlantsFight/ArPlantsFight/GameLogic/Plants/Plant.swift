//
//  Plant.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 26.06.24.
//

import Foundation
import RealityKit

@Observable
class Plant {
    var liveAmount: Int
    var expense: Int
    var pace: TimeInterval
    var projectileMovementSpeed: TimeInterval
    var dmgAmountProjectile: Int
    
    var plantEntity: Entity = Entity()
    var shooting: Bool = false
    var position: (Int, Int) = (0,0)
    
    private final var projetileMesh = MeshResource.generateSphere(radius: 0.01)
    private final var projetileMaterial = SimpleMaterial(color: .green, isMetallic: false)
    
    // Internal initializer to prevent instantiation of Plant directly
    init(liveAmount: Int, expense: Int, pace: TimeInterval, projectileMovementSpeed: TimeInterval, dmgAmountProjectile: Int) {
        self.liveAmount = liveAmount
        self.expense = expense
        self.pace = pace
        self.projectileMovementSpeed = projectileMovementSpeed
        self.dmgAmountProjectile = dmgAmountProjectile
    }
    
    // Required initializer to ensure subclasses implement their own initializers
    required init() {
        fatalError("This class cannot be instantiated directly")
    }
    
    func createPlant(modelName: String, widthIndex: Int, lenghtIndex: Int) -> Entity? {
        // Load the USDZ model
        guard let modelEntity = try? ModelEntity.load(named: modelName) else {
            print("Failed to load model")
            return nil
        }
        
        plantEntity = modelEntity
        position = (widthIndex, lenghtIndex)
        
        return modelEntity
    }
    
    func createPlant(widthIndex: Int, lenghtIndex: Int) -> Entity? {
        fatalError("This class cannot create a plant directly")
    }
    
    func shootProjectiles(viewModel: ArViewModel) {
        Timer.scheduledTimer(withTimeInterval: pace, repeats: shooting) {_ in
            let projectileEntity = ModelEntity(mesh: self.projetileMesh, materials: [self.projetileMaterial])
            let projectileHight: Float = 0.06
            
            projectileEntity.position = [viewModel.tileWidth*Float(self.position.0), projectileHight,viewModel.tileWidth*Float(self.position.1)]
            viewModel.worldEntity.addChild(projectileEntity)
            
            viewModel.projectiles[self.position.1].append(projectileEntity)
            
            let duration = (Double(viewModel.width) - Double(self.position.0)) * self.projectileMovementSpeed
            
            projectileEntity.move(to: Transform(
                scale: projectileEntity.transform.scale,
                rotation: projectileEntity.transform.rotation,
                translation: [viewModel.tileWidth * Float(viewModel.width), projectileHight, viewModel.tileWidth * Float(self.position.1)]
            ), relativeTo: viewModel.worldEntity, duration: duration, timingFunction: .linear)
            
            // Use a Timer to simulate the completion handler
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
                if let laneIndex = viewModel.projectiles[self.position.1].firstIndex(of: projectileEntity) {
                    viewModel.projectiles[self.position.1].remove(at: laneIndex)
                    viewModel.worldEntity.removeChild(projectileEntity)
                }
            }
        }
    }
}
