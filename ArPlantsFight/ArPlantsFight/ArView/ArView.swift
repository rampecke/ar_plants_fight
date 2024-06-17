//
//  ArView.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 17.06.24.
//

import SwiftUI
import RealityKit

struct ArView: View {
    @Bindable var arViewModel: ArViewModel
    
    var body: some View {
        ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ArViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        //let anchor = AnchorEntity(plane: .horizontal, classification: .table)
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0, 0)))
        arViewModel.anchorWorld(arView: arView, anchor: anchor)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
