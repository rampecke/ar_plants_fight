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
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .table, minimumBounds: SIMD2<Float>(0, 0)))
        arViewModel.anchorWorld(arView: arView, anchor: anchor)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGestureRecognizer)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        arViewModel.updateView()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arViewModel: arViewModel)
    }
    
    class Coordinator: NSObject {
        var arViewModel: ArViewModel
        
        init(arViewModel: ArViewModel) {
            self.arViewModel = arViewModel
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView else { return }
            let location = sender.location(in: arView)
            
            let hitResults = arView.hitTest(location)
            if !hitResults.isEmpty {
                arViewModel.handleTileTap(hitEntity: hitResults[0].entity)
            }
        }
    }
}
