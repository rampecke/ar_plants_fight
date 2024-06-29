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
//        //let anchor = AnchorEntity(plane: .horizontal, classification: .table)
//        // Add tap gesture recognizer
//        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
//        arView.addGestureRecognizer(tapGestureRecognizer)
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .table, minimumBounds: SIMD2<Float>(0, 0)))
        arViewModel.anchorWorld(arView: arView, anchor: anchor)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        arViewModel.moveZombies()
    }
    
//    func makeCoordinator() -> Coordinator {
//            Coordinator(arViewModel: arViewModel)
//    }
    
//    class Coordinator: NSObject {
//            var arViewModel: ArViewModel
//            
//            init(arViewModel: ArViewModel) {
//                self.arViewModel = arViewModel
//            }
//            
//            @objc func handleTap(_ sender: UITapGestureRecognizer) {
//                guard let arView = sender.view as? ARView else { return }
//                let location = sender.location(in: arView)
//                
//                // Perform raycast
//                if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
//                    let position = simd_make_float3(result.worldTransform.columns.3)
//                    print(position)
//                    // Add the plant to the tapped tile
//                    //arViewModel.addPlantToPosition(widthIndex: 0, lenghtIndex: 0)
//                }
//            }
//        }
}
