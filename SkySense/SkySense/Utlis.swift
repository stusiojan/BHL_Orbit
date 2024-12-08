//
//  Utlis.swift
//  SkySense
//
//  Created by Jan Stusio on 07/12/2024.
//

import CoreLocation
import SceneKit

struct Utilities {

    static let referenceEpoch: Double = 2000.0
    
    static func calculatePosition(star: Star, userLocation: CLLocation = CLLocation(latitude: 0, longitude: 0), currentTime: Date) -> SCNVector3 {
        // 1. Convert RA and Dec to decimal degrees
        let raDecimal = raToDecimalDegrees(ra: star.ra)
        let decDecimal = decToDecimalDegrees(dec: star.dec)
        
        // 2. Adjust for user's location and time
        let lst = calculateLST(userLocation: userLocation, currentTime: currentTime)
        let hourAngle = lst - raDecimal
        
        // 3. Convert to Cartesian coordinates (using HA instead of RA if calculated)
        let distance: Double = star.distance
        var x = distance * cos(decDecimal.degreesToRadians) * cos(hourAngle.degreesToRadians)
        var y = distance * cos(decDecimal.degreesToRadians) * sin(hourAngle.degreesToRadians)
        var z = distance * sin(decDecimal.degreesToRadians)
        
        
        if y < 1 {
            y *= 100
            // simplified for demo purpuses
            if y < 0 {
                y *= -1
            }
        }
        if z < 1 {
            z *= 100
        }
        if x < 1 {
            x *= 100
        }
        
        
        print("x: \(x), y: \(y), z: \(z)")
        let position = SCNVector3(x, y, z)
        return position
    }
 
    static func raToDecimalDegrees(ra: String) -> Double {
        let components = ra.components(separatedBy: " ")
        let hours = Double(components[0].dropLast()) ?? 0
        let minutes = Double(components[1].dropLast()) ?? 0
        let seconds = Double(components[2].dropLast()) ?? 0
        return (hours + minutes/60 + seconds/3600) * 15
    }
 
    static func decToDecimalDegrees(dec: String) -> Double {
        let components = dec.components(separatedBy: " ")
        let degrees = Double(components[0].dropLast()) ?? 0
        let arcminutes = Double(components[1].dropLast()) ?? 0
        let arcseconds = Double(components[2].dropLast()) ?? 0
        return degrees + arcminutes/60 + arcseconds/3600
    }
 
    static func getYearsSinceEpoch(currentTime: Date) -> Double {
        let calendar = Calendar.current
        let epochDateComponents = DateComponents(year: Int(referenceEpoch))
        guard let epochDate = calendar.date(from: epochDateComponents) else { return 0 }
        let difference = currentTime.timeIntervalSince(epochDate)
        return difference / (60 * 60 * 24 * 365.25)
    }
 
    // Local Sidereal Time
    static func calculateLST(userLocation: CLLocation, currentTime: Date) -> Double {
        let longitude = userLocation.coordinate.longitude
        let daysSinceEpoch = getYearsSinceEpoch(currentTime: currentTime) * 365.25
        let lst = 100.46 + 0.985647 * daysSinceEpoch + longitude + 15 * currentTime.timeIntervalSince(Date(timeIntervalSince1970: 0)) / 3600
        return lst.truncatingRemainder(dividingBy: 360)
    }
}

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
