//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by fox on 19/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation
import JFCore


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var location: WKInterfaceLabel!
    @IBOutlet weak var placemark: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
   
    var currentLocation : CLLocation?
    #if targetEnvironment(simulator)
    var placemarks : [Placemark]?
    #else
    var placemarks : [CLPlacemark]?
    #endif

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        image.setImage(UIImage.init(named: "background"))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        observeLocationServices()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        unobserveLocationServices()
    }

    fileprivate func observeLocationServices()
    {
        unobserveLocationServices()
        
        let queue = OperationQueue.main
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name(rawValue: JFCore.Constants.Notification.locationUpdated), object: nil, queue: queue) {
            [weak self] (NSNotification) in
            guard let locs = LocationManager.instance.locations,
                let f = locs.first,
                let strong = self else {
                    return
            }
            strong.location.setText(strong.locationDescription(f))
            strong.currentLocation = f
            strong.reverseLocation(f)
        }
        
        nc.addObserver(forName: NSNotification.Name(rawValue: JFCore.Constants.Notification.locationError), object: nil, queue: queue) {
            [weak self]
            note in
            if let _: Error = note.object as? Error,
                let strong = self {
                strong.locationRestart()
            }
        }
        
        nc.addObserver(forName: NSNotification.Name(rawValue: JFCore.Constants.Notification.locationAuthorized), object: nil, queue: queue) {
            (NSNotification) in
            if !JFCore.LocationManager.instance.isAuthorized() {
                // do nothing
            }
        }
    }
    
    func locationTitle(_ currentLocation : CLLocation) -> String {
        return currentLocation.title()
    }
    
    func locationDescription(_ currentLocation : CLLocation) -> String {
        return currentLocation.longDescription()
    }
    
    
    func placemarkDescription(_ placemark : CLPlacemark) -> String {
        return placemark.longDescription()
    }
    
    
    fileprivate func locationRestart() {
        JFCore.Common.synchronized(syncBlock: {
            LocationManager.instance.stop()
            LocationManager.instance.start()
        })
    }
    
    fileprivate func unobserveLocationServices()
    {
        for notification in [JFCore.Constants.Notification.locationUpdated,
                             JFCore.Constants.Notification.locationError,
                             JFCore.Constants.Notification.locationAuthorized] {
                                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notification), object: nil);
        }
    }
    
    
    func reverseLocation(_ location : CLLocation) {
        #if targetEnvironment(simulator)
        placemarks = [Placemark.init()]
        placemark.setText(placemarks?.first?.country)
        #else
        LocationManager.instance.reverseLocation(location: location, didFailWithError: { (jferror) in
        }) { [weak self] (placemarks) in
            guard let strong = self else { return }
            Analytics.logFunction(function: #function, parameters: ["location" : "\(placemarks.count)" as AnyObject])
            if let f = placemarks.first {
                strong.placemark.setText(strong.placemarkDescription(f))
            }
            strong.placemarks = placemarks
        }
        #endif
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "list" {
            return placemarks
        }
        return nil
    }

}

#if targetEnvironment(simulator)
struct Placemark {
    init() {
    }
    
    lazy var name: String? = { return "Apple Inc." }()
    lazy var thoroughfare: String? = { return "Infinite Loop" }()
    lazy var subThoroughfare: String? = { return "1" }()
    let locality: String? = { return "Cupertino" }()
    lazy var subLocality: String? = { return "Mission District" }()
    lazy var administrativeArea: String? = { return "CA" }()
    lazy var subAdministrativeArea: String? = { return "Santa Clara" }()
    lazy var postalCode: String? = { return "95014" }()
    lazy var isoCountryCode: String? = { return "US" }()
    let country: String? = { return "United States" }()
    lazy var inlandWater: String? = { return "Lake Tahoe" }()
    lazy var ocean: String? = { return "Pacific Ocean" }()
    lazy var areasOfInterest: [String]? = { return ["Golden Gate Park"] }()
}
#endif
