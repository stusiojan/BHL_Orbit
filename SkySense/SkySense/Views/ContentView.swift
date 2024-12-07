//
//  ContentView.swift
//  SkySense
//
//  Created by Jan Stusio on 07/12/2024.
//

import SwiftUI
import ARKit
 
struct ContentView: View {
    @StateObject var locationManager = LocationManager()
 
    var body: some View {
        ZStack {
            ARViewContainer(location: locationManager.currentLocation)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

