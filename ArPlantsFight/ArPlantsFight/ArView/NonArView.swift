//
//  NonArView.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 17.06.24.
//

import SwiftUI
import RealityKit

struct NonArView: View {
    @Bindable var arViewModel: ArViewModel
    
    var body: some View {
        VStack{
            NonARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
        }
    }
}

struct NonARViewContainer: UIViewRepresentable {
    var arViewModel: ArViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: true)
        
        //Create Lighting
        let pointLight = PointLight()
        pointLight.light.intensity = 10000
        let lightAnchor = AnchorEntity(world: [0,1,0])
        lightAnchor.addChild(pointLight)
        arView.scene.addAnchor(lightAnchor)
        
        
        //Createworld
        let worldAnchor = AnchorEntity(world: [0,0,0])
        arViewModel.anchorWorld(arView: arView, anchor: worldAnchor)
        
        //Camera
        let camera = PerspectiveCamera()
        let cameraAnchor = AnchorEntity(world: [0,0.2,arViewModel.tileWidth*Float(arViewModel.length) + 0.4])
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}
