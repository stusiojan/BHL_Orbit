//
//  data.swift
//  SkySense
//
//  Created by Jan Stusio on 07/12/2024.
//

import CoreLocation
 

enum CelestialBody: String, Codable, CaseIterable {
    case mars = "mars"
    case venus = "venus"
    case cass = "cass"
    case dipp = "dipp"
}

struct Star {
    let name: String
    let ra: String  // Right Ascension
    let dec: String // Declination 
    let distance: Double // Distance in light-years (or parsecs)
}

 
struct ConstellationData {
    static let mockData: [Star] = [
//        Star(name: "Star 1", ra: "17h 57m 47.77s", dec: "+04deg 44' 01.1\"", distance: 0.5),
        Star(name: CelestialBody.mars.rawValue, ra: "8h 37m 14s", dec: "+21deg 30' 01.1\"", distance: 0.76),
        Star(name: CelestialBody.venus.rawValue, ra: "20h 20m 48s", dec: "-21° 53′ 53\"", distance: 0.925570),
        Star(name: "Vega", ra: "18h 36m 56.33635s", dec: "+38° 47' 01.2914\"", distance: 1583556.5703),
        Star(name: "Arcturus", ra: "14h 15m 39.7s", dec: "+19° 10' 57\"", distance: 2320947.5291),
        Star(name: "Sirius", ra: "06h 45m 08.91728s", dec: "−16° 42' 58.0171\"", distance: 543873.26296)
    ]
}
