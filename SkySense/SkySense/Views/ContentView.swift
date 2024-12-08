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
    @StateObject var audioManager = AudioManager()
    @State private var counter: Int = 0
 
    var body: some View {
        ZStack {
            ARViewContainer(location: locationManager.currentLocation)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onTapGesture {
            counter += 1
            if counter.isMultiple(of: 2) { audioManager.playFollowup(body: CelestialBody.venus) }
            else if counter.isMultiple(of: 3) { audioManager.stopAllPlayers()}
            else { audioManager.playInitial(body: CelestialBody.venus) }
        }
        .sensoryFeedback(.impact, trigger: counter)
    }
}

