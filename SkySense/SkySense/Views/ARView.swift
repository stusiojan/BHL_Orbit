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
                
                // Create a node for the star (e.g., a sphere or text)
                let sphere = SCNSphere(radius: 0.5) // Adjust radius as needed
                sphere.firstMaterial?.diffuse.contents = UIColor.yellow // Adjust color as needed
                let starNode = SCNNode(geometry: sphere)
                
                // Add a label to the star
                let textGeometry = SCNText(string: star.name, extrusionDepth: 0.1)
                textGeometry.firstMaterial?.diffuse.contents = UIColor.white
                let textNode = SCNNode(geometry: textGeometry)
                textNode.scale = SCNVector3(1, 1, 1) // Adjust scale as needed
                textNode.position = SCNVector3(0, -1, 0) // Adjust label position as needed
                
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
