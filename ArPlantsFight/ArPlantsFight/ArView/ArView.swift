//
//  ArView.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 17.06.24.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

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
//        // Configure AR session for horizontal plane detection
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal
//        arView.session.run(configuration)
        
        //Add tap gesture delegate
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGestureRecognizer)
        
        // Subscribe to collision events
        context.coordinator.setupCollisionSubscriptions(in: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        arViewModel.updateView()
        
        if arViewModel.killCounter == arViewModel.zombieSpawnPattern.count {
            //Remove the timers for the plants
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arViewModel: arViewModel)
    }
    
    class Coordinator: NSObject {
        var arViewModel: ArViewModel
        var subscriptions = Set<AnyCancellable>()
        
        init(arViewModel: ArViewModel) {
            self.arViewModel = arViewModel
        }
        
        func setupCollisionSubscriptions(in arView: ARView) {
            arView.scene.subscribe(to: CollisionEvents.Began.self) { event in
                self.handleCollision(event: event)
            }.store(in: &subscriptions)
        }
        
        func handleCollision(event: CollisionEvents.Began) {
            guard let entityA = event.entityA as? ModelEntity,
                  let entityB = event.entityB as? ModelEntity else { return }
            
            let groupA = entityA.collision?.filter.group
            let groupB = entityB.collision?.filter.group
            
            // Handle collision based on groups
            if groupA == CollisionGroups.zombie && groupB == CollisionGroups.plant {
                arViewModel.zombieHitPlant(zombieEntity: entityA, plantEntity: entityB, viewModel: arViewModel)
            } else if groupA == CollisionGroups.projectile && groupB == CollisionGroups.zombie {
                arViewModel.removeEntityFromProjectiles(projectileEntity: entityA, zombieEntity: entityB, viewModel: arViewModel)
            } else if groupA == CollisionGroups.zombie && groupB == CollisionGroups.goalWall {
                arViewModel.gameLost = true
            }
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView else { return }
            let location = sender.location(in: arView)
            
//            if !arViewModel.worldEntityWasAnchored {
//                if let result = arView.raycast(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal).first {
//                    let position = SIMD3<Float>(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
//                    let anchor = AnchorEntity(world: position)
//                    arViewModel.anchorWorld(arView: arView, anchor: anchor)
//                }
//                return
//            }
            
            let hitResults = arView.hitTest(location)
            //Add the plant to the first entity with collision type tile
            if let tileEntity = hitResults
                .compactMap({ $0.entity as? ModelEntity })  // Try to cast to ModelEntity
                .first(where: { $0.collision?.filter.group == CollisionGroups.tile }) {
                    arViewModel.handleTileTap(hitEntity: tileEntity)
                }
        }
    }
}

struct CollisionGroups {
    static let tile = CollisionGroup(rawValue: 1 << 0)
    static let plant = CollisionGroup(rawValue: 1 << 1)
    static let zombie = CollisionGroup(rawValue: 1 << 2)
    static let projectile = CollisionGroup(rawValue: 1 << 3)
    static let goalWall = CollisionGroup(rawValue: 1 << 4)
}
