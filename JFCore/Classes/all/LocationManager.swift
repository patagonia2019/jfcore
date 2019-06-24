//
//  LocationManager.swift
//  Xoshem-watch
//
//  Created by Javier Fuchs on 10/7/15.
//  Copyright © 2015 Fuchs. All rights reserved.
//

import Foundation
import CoreLocation

/*
 *  LocationManager
 *
 *  Discussion:
 *    Manager of location manager services, the only point in the application where the current location/placement
 *    were informed and saved.
 *    It triggers a kLocationUpdated notification telling the new locality/country
 *
 *    Location services only works on iPhone/iPad.
 */

public class LocationManager: NSObject, CLLocationManagerDelegate {

    //
    // Attributes only modified by this class
    //
    private var locationManager: CLLocationManager = CLLocationManager()
    
    public var currentLocation: CLLocation?
    public var currentPlacemark: CLPlacemark?
    public var locations: [CLLocation]?
    private var running : Bool?

    public func isRunning() -> Bool {
        if let _running = self.running {
            return _running
        }
        return false
    }

    public static let instance = LocationManager()

    //
    // initialization
    //

    private func setup() {
        locationManager.delegate = self
        #if os(tvOS)
        locationManager.requestWhenInUseAuthorization()
        #elseif os(watchOS)
        locationManager.requestAlwaysAuthorization()
        #else
        locationManager.requestAlwaysAuthorization()
        #endif
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //
    // start location service
    //
    public func start()
    {
        setup()
//        #if os(watchOS)
//        locationManager.startUpdatingLocation()
//        #else
        locationManager.requestLocation()
//        #endif
        running = true
    }
    
    
    //
    // stop location service
    //
    public func stop()
    {
        running = false
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    public func reverseLocation(location: CLLocation, didFailWithError:@escaping (_ error: JFError) -> Void,
                                didUpdatePlacemarks:@escaping (_ placemarks: [CLPlacemark]) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if let myerror = error {
                didFailWithError(JFError(myerror as NSError?))
            }
            else if let myplacemarks = placemarks {
                didUpdatePlacemarks(myplacemarks)
            }
            else {
                let myerror = JFError(code: JFCore.Constants.ErrorCode.LocMgrNoPlaceMarksFound.rawValue,
                                    desc: "Failed at rever geocode",
                                    reason: "Reverse Location failed on get the placements for the given location",
                                    suggestion: "\(#file):\(#line):\(#column):\(#function)", underError: error as NSError?)

                didFailWithError(myerror)
            }
        }
    }
    
    public func notifyName(aName: String, object anObject: AnyObject?) {
        if self.isRunning() {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: aName), object: anObject)
        }
    }
    
    
    public func isAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    private func notifyChanges(locations : [CLLocation]) {
        self.locations = locations
        self.notifyName(aName: JFCore.Constants.Notification.locationUpdated, object: nil)
    }
    
    //
    // Delegate rules
    //
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        let e = JFError(code: JFCore.Constants.ErrorCode.LocMgrNoLocationsDetected.rawValue, desc: "CLLocationManager failed",
                        reason: "When trying to get the location",
                        suggestion: "\(#file):\(#line):\(#column):\(#function)",
            underError: error as NSError)
        if self.isRunning() {
            self.stop()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: JFCore.Constants.Notification.locationError), object: e)
        }
    }
    

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        var notifyChange = true
        
        guard let currentLocations = self.locations else {
            // No current locations, just notify the new loctions updated
            self.notifyChanges(locations: locations)
            return
        }
        
        if locations.count > 0 {

            // compare the locations, if one of the objects is the same, is not necessary to notify
            mainFor: for locationA in locations {
                for locationB in currentLocations {
                    if locationB.altitude == locationA.altitude &&
                       locationB.coordinate.latitude == locationA.coordinate.latitude &&
                       locationB.coordinate.longitude == locationA.coordinate.longitude {
                        notifyChange = false
                        break mainFor
                    }
                }
            }
            
            if (notifyChange) {
                self.notifyChanges(locations: locations)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            self.notifyName(aName: JFCore.Constants.Notification.locationAuthorized, object: nil)
        }
    }
    

}
