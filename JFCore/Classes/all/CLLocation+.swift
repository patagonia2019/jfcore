//
//  CLLocation+.swift
//  Pods
//
//  Created by fox on 23/06/2019.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    public func title() -> String {
        var aux : String = "["
        aux += "\(coordinate.latitude);"
        aux += "\(coordinate.longitude)"
        aux += "]"
        return aux
    }
    
    public func longDescription() -> String {
        var level : Int = 0
        #if !os(macOS)
        if let floor = floor {
            level = floor.level
        }
        #endif
        var aux : String = "["
        aux += "\(coordinate.latitude);"
        aux += "\(coordinate.longitude);"
        aux += "\(altitude);"
        aux += "\(horizontalAccuracy);"
        aux += "\(verticalAccuracy);"
        aux += "\(level)"
        aux += "]"
        return aux
    }

}
