//
//  ModelLoader.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 08.07.24.
//

import Foundation
import RealityKit
import ARKit

class ModelLoader {
    private var sunflowerModel: ModelEntity?
    private var basicModel: ModelEntity?
    private var walnutModel: ModelEntity?
    
    init() {
        self.sunflowerModel = loadModel(modelName: "Sunflower")
        self.basicModel = loadModel(modelName: "BasePlant")
        self.walnutModel = loadModel(modelName: "Walnut")
    }
    
    private func loadModel(modelName: String) -> ModelEntity? {
        guard let modelEntity = try? ModelEntity.loadModel(named: modelName) else {
            print("Failed to load model")
            return nil
        }
        return modelEntity
    }
    
    func returnCopyOf(plantType: PlantTypes) -> ModelEntity? {
        guard let modelEntity = switch plantType {
        case .Sunflower:
            sunflowerModel?.clone(recursive: true)
        case .Walnut:
            walnutModel?.clone(recursive: true)
        case .BasicPlant:
            basicModel?.clone(recursive: true)
        } else {
            print("Failed to load model")
            return nil
        }
        
        return modelEntity
    }
}
