//
//  ARView.swift
//  SkySense
//
//  Created by Jan Stusio on 07/12/2024.
//

import SwiftUI
import ARKit
import CoreLocation
import RealityKit

/// Holds AR view with rendered stars
struct ARViewContainer: UIViewRepresentable {
    
    var location: CLLocation?
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.session.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading // Align to real-world direction
        arView.session.run(configuration)
        
        arView.autoenablesDefaultLighting = true
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if let location = location {
            context.coordinator.updateConstellations(for: location, in: uiView)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var constellationNodes: [SCNNode] = []
        
        func updateConstellations(for location: CLLocation, in arView: ARSCNView) {
            // Remove existing constellation nodes
            constellationNodes.forEach { $0.removeFromParentNode() }
            constellationNodes.removeAll()
            
            let stars = ConstellationData.mockData
            for star in stars {
                let position = Utilities.calculatePosition(star: star, userLocation: CLLocation(latitude: 0, longitude: 0), currentTime: Date())
                
                // Create a node for the star
                var sphereRadius: Double = 0.5
                position.y > 150 ? (sphereRadius *= Double(position.y/1000)) : (sphereRadius = 0.5)
                
                let sphere = SCNSphere(radius: sphereRadius)
                sphere.firstMaterial?.diffuse.contents = UIColor.yellow
                let starNode = SCNNode(geometry: sphere)
                
                // Add a label to the star
                let textGeometry = SCNText(string: star.name, extrusionDepth: 0.1)
                textGeometry.firstMaterial?.diffuse.contents = UIColor.white
                let textNode = SCNNode(geometry: textGeometry)
                textNode.scale = SCNVector3(0.1, 0.1, 0.1)
                textNode.position = SCNVector3(0, -1, 0)
                
                starNode.addChildNode(textNode)
                starNode.position = position
                arView.scene.rootNode.addChildNode(starNode)
                constellationNodes.append(starNode)
            }
        }
        
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            
        }
    }
}
