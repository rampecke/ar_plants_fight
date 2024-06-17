//
//  ArViewModel.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 17.06.24.
//

import Foundation
import RealityKit

@Observable
class ArViewModel {
    var arMode: ArMode = .AR
    let tileHeight: Float = 0.001
    let tileWidth: Float =  0.05
    var width: Int
    var length: Int
    
    var worldEntity: Entity = Entity()
    var arWorldWasCreated: Bool = false
    
    init(width: Int, length: Int) {
        self.width = width
        self.length = length
    }
    
    func toggleArMode() {
        if(arMode == .AR) {
            arMode = .NonAR
        } else {
            arMode = .AR
        }
    }
    
    //AR Functions
    func createArWorld() {
        let floorTileMesh = MeshResource.generateBox(width: tileWidth, height: tileHeight, depth: tileWidth)
        
        for i in 0...width-1 {
            for j in 0...length-1 {
                let entity = ModelEntity(mesh: floorTileMesh, materials: [getColorFloorTile(widthIndex: i, lenghtIndex: j)])
                entity.position = [tileWidth*Float(i),0,tileWidth*Float(j)]
                worldEntity.addChild(entity)
            }
        }
    }
    
    private func getColorFloorTile(widthIndex: Int, lenghtIndex: Int) -> SimpleMaterial {
        let floorTileMaterial = SimpleMaterial(color: SimpleMaterial.Color(named: "gras_dark") ?? .gray, roughness: 0.5, isMetallic: true)
        let floorTileMaterial2 = SimpleMaterial(color: SimpleMaterial.Color(named: "gras_light") ?? .green, roughness: 0.5, isMetallic: true)
        
        if widthIndex % 2 == 0 {
            if lenghtIndex % 2 == 0 {
              return floorTileMaterial
            } else {
                return floorTileMaterial2
            }
        } else {
            if lenghtIndex % 2 == 0 {
                return floorTileMaterial2
            } else {
                return floorTileMaterial
            }
        }
    }
    
    func anchorWorld(arView: ARView, anchor: AnchorEntity) {
        if(!arWorldWasCreated) {
            createArWorld()
            arWorldWasCreated = true
        }
        //Reposition because of Offset
        worldEntity.position = [-(tileWidth * Float(width)/2), 0, -(tileWidth * Float(length)/2)]
        anchor.addChild(self.worldEntity)
        arView.scene.addAnchor(anchor)
    }
}

enum ArMode {
    case AR
    case NonAR
}
