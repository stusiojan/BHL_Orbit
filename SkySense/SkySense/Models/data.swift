//
//  data.swift
//  SkySense
//
//  Created by Jan Stusio on 07/12/2024.
//

import CoreLocation
 
struct Star {
    let name: String
    let ra: String  // Right Ascension (e.g., "17h 57m 47.77s")
    let dec: String // Declination (e.g., "+04deg 44' 01.1\"")
    let distance: Double // Distance in light-years (or parsecs)
}

 
struct ConstellationData {
    static let mockData: [Star] = [
        Star(name: "Star 1", ra: "17h 57m 47.77s", dec: "+04deg 44' 01.1\"", distance: 0.5),
        Star(name: "Mars", ra: "8h 37m 14s", dec: "+21deg 30' 01.1\"", distance: 0.76),
        Star(name: "Vega", ra: "18h 36m 56.33635s", dec: "+38° 47' 01.2914\"", distance: 25.04),
        Star(name: "Arcturus", ra: "14h 15m 39.7s", dec: "+19° 10' 57\"", distance: 36.7),
        Star(name: "Sirius", ra: "06h 45m 08.91728s", dec: "−16° 42' 58.0171\"", distance: 8.6)
    ]
}
