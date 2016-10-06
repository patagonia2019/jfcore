//
//  ViewController.swift
//  JFCore
//
//  Created by Javier Fuchs on 08/28/2016.
//  Copyright © 2016 Mobile Patagonia. All rights reserved.
//

import UIKit
import JFCore

class ViewController: BaseViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var placemark: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    var location : CLLocation?
    var placemarks : [CLPlacemark]?
    
    override func viewDidLoad() {
        self.title = "test"
        super.viewDidLoad()

        if let image = UIImage.init(named: "background") {
            self.view.backgroundColor = image.patternColor(UIScreen.mainScreen().bounds.size)
        }
        self.logCurrentLanguage()
        
        self.navigationItem.setAccessHeader("This is the header")
        
        self.label.setAccessLabel()
        self.placemark.setAccessLabel()
        self.button.setAccessButton("This is the button")
        self.image.setAccessImage("This is the image")
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.observeLocationServices()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unobserveLocationServices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Analytics.logMemoryWarning(#function, line: #line)
    }

    private func observeLocationServices()
    {
        self.unobserveLocationServices()
        
        let queue = NSOperationQueue.mainQueue()
        NSNotificationCenter.defaultCenter()
            .addObserverForName(JFCore.Constants.Notification.locationUpdated, object: nil, queue: queue) {
                [weak self] (NSNotification) in
                guard let locs = LocationManager.instance.locations,
                    f = locs.first,
                    strong = self else {
                        return
                }
                strong.label.text = strong.locationDescription(f)
                strong.location = f
                strong.label.setAccessLabel()
                strong.reverseLocation(f)
        }
        
        NSNotificationCenter.defaultCenter()
            .addObserverForName(JFCore.Constants.Notification.locationError, object: nil, queue: queue) {
                [weak self]
                note in
                if let _: Error = note.object as? Error,
                   let strong = self {
                    strong.locationRestart()
                }
        }
        
        NSNotificationCenter.defaultCenter()
            .addObserverForName(JFCore.Constants.Notification.locationAuthorized, object: nil, queue: queue) {
                (NSNotification) in
                if !JFCore.LocationManager.instance.isAuthorized() {
                    // do nothing
                }
        }
    }
    
    func locationTitle(location : CLLocation) -> String {
        var aux : String = "["
        aux += "\(location.coordinate.latitude);"
        aux += "\(location.coordinate.longitude)"
        aux += "]"
        return aux
    }

    func locationDescription(location : CLLocation) -> String {
        var level : Int = 0
        if let floor = location.floor {
            level = floor.level
        }
        var aux : String = "["
        aux += "\(location.coordinate.latitude);"
        aux += "\(location.coordinate.longitude);"
        aux += "\(location.altitude);"
        aux += "\(location.horizontalAccuracy);"
        aux += "\(location.verticalAccuracy);"
        aux += "\(level)"
        aux += "]"
        return aux
    }
    
    
    func placemarkDescription(placemark : CLPlacemark) -> String {
        
        var aux : String = "["
        if let _administrativeArea = placemark.administrativeArea {
            aux += "\(_administrativeArea);"
        } else { aux += "();" }
        if let _areasOfInterest = placemark.areasOfInterest {
            aux += "\(_areasOfInterest);"
        } else { aux += "();" }
        if let _country = placemark.country {
            aux += "\(_country);"
        } else { aux += "();" }
        if let _inlandWater = placemark.inlandWater {
            aux += "\(_inlandWater);"
        } else { aux += "();" }
        if let _isoCountryCode = placemark.ISOcountryCode {
            aux += "\(_isoCountryCode);"
        } else { aux += "();" }
        if let _locality = placemark.locality {
            aux += "\(_locality);"
        } else { aux += "();" }
        if let _name = placemark.name {
            aux += "\(_name);"
        } else { aux += "();" }
        if let _ocean = placemark.ocean {
            aux += "\(_ocean);"
        } else { aux += "();" }
        if let _postalCode = placemark.postalCode {
            aux += "\(_postalCode);"
        } else { aux += "();" }
        if let _subAdministrativeArea = placemark.subAdministrativeArea {
            aux += "\(_subAdministrativeArea);"
        } else { aux += "();" }
        if let _subLocality = placemark.subLocality {
            aux += "\(_subLocality);"
        } else { aux += "();" }
        if let _subThoroughfare = placemark.subThoroughfare {
            aux += "\(_subThoroughfare);"
        } else { aux += "();" }
        if let _thoroughfare = placemark.thoroughfare {
            aux += "\(_thoroughfare);"
        } else { aux += "();" }
        if let _location = placemark.location {
            aux += "\(_location.description)"
        } else { aux += "()" }
        aux += "]"
        return aux
    }

    
    private func locationRestart() {
        JFCore.Common.synchronized({
            LocationManager.instance.stop()
            LocationManager.instance.start()
        })
    }
    
    private func unobserveLocationServices()
    {
        for notification in [JFCore.Constants.Notification.locationUpdated,
                             JFCore.Constants.Notification.locationError,
                             JFCore.Constants.Notification.locationAuthorized] {
                                NSNotificationCenter.defaultCenter().removeObserver(self, name: notification, object: nil);
        }
    }
    
    private func logCurrentLanguage()
    {
        if let locale : NSLocale = NSLocale.currentLocale() {
            for key in [NSLocaleIdentifier, NSLocaleLanguageCode, NSLocaleCountryCode, NSLocaleScriptCode, NSLocaleVariantCode, NSLocaleUsesMetricSystem, NSLocaleMeasurementSystem, NSLocaleDecimalSeparator] {
                if let name = locale.objectForKey(key) {
                    Analytics.logFunction(#function, parameters: [key : String(name)])
                }
            }
            if let calendar = locale.objectForKey(NSLocaleCalendar) as? NSCalendar {
                Analytics.logFunction(#function, parameters: [NSLocaleCalendar : calendar.calendarIdentifier])
            }
        }
    }

    
    func reverseLocation(location : CLLocation) {
                LocationManager.instance.reverseLocation(location,
                    didFailWithError: { (error) in
                        let myerror = Error(code: 10,
                            desc: "Error on Placemarks",
                            reason: "Error on Location/Placemarks import",
                            suggestion: "\(#file):\(#line):\(#column):\(#function)", underError: error as NSError)
                        Analytics.logFatal(myerror)
                        myerror.fatal()
                    },
                    didUpdatePlacemarks: { [weak self] (placemarks) in
                        guard let strong = self else { return }
                        Analytics.logFunction(#function, parameters: ["location" : "\(placemarks.count)"])
                        if let f = placemarks.first {
                            strong.placemark.text = strong.placemarkDescription(f)
                        }
                        strong.placemark.setAccessLabel()
                        strong.placemarks = placemarks
                    })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "list" {
            let vc:ListViewController = segue.destinationViewController as! ListViewController
            guard let ps = self.placemarks,
                      l = self.location else {
                        return
            }
            vc.placemarks = ps
            vc.title = self.locationTitle(l)
        }
    }
    
}

