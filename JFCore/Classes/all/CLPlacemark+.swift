//
//  CLPlacemark+.swift
//  Pods
//
//  Created by fox on 23/06/2019.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    public func longDescription() -> String {
        
        var aux : String = "["
        if let administrativeArea = administrativeArea {
            aux += "\(administrativeArea);"
        } else { aux += "();" }
        if let areasOfInterest = areasOfInterest {
            aux += "\(areasOfInterest);"
        } else { aux += "();" }
        if let country = country {
            aux += "\(country);"
        } else { aux += "();" }
        if let inlandWater = inlandWater {
            aux += "\(inlandWater);"
        } else { aux += "();" }
        if let isoCountryCode = isoCountryCode {
            aux += "\(isoCountryCode);"
        } else { aux += "();" }
        if let locality = locality {
            aux += "\(locality);"
        } else { aux += "();" }
        if let name = name {
            aux += "\(name);"
        } else { aux += "();" }
        if let ocean = ocean {
            aux += "\(ocean);"
        } else { aux += "();" }
        if let postalCode = postalCode {
            aux += "\(postalCode);"
        } else { aux += "();" }
        if let subAdministrativeArea = subAdministrativeArea {
            aux += "\(subAdministrativeArea);"
        } else { aux += "();" }
        if let subLocality = subLocality {
            aux += "\(subLocality);"
        } else { aux += "();" }
        if let subThoroughfare = subThoroughfare {
            aux += "\(subThoroughfare);"
        } else { aux += "();" }
        if let thoroughfare = thoroughfare {
            aux += "\(thoroughfare);"
        } else { aux += "();" }
        if let location = location {
            aux += "\(location.description)"
        } else { aux += "()" }
        aux += "]"
        return aux
    }

}
