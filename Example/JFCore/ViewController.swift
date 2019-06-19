//
//  ViewController.swift
//  JFCore
//
//  Created by Javier Fuchs on 08/28/2016.
//  Copyright © 2016 Mobile Patagonia. All rights reserved.
//

import UIKit
import CoreLocation
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

        if let img = UIImage.init(named: "background") {
            self.view.backgroundColor = img.patternColor(customSize: UIScreen.main.bounds.size)
            let topImage = UIImage.init(named: "bird")
            let mergedImage = img.combineImages(topImage: topImage!)
            image.image = mergedImage
        }
        self.logCurrentLanguage()
        
        self.navigationItem.setAccessHeader(string: "This is the header")
        
        self.label.setAccessLabel()
        self.placemark.setAccessLabel()
        self.button.setAccessButton(string: "This is the button")
        self.image.setAccessImage(string: "This is the image")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.observeLocationServices()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unobserveLocationServices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Analytics.logMemoryWarning(function: #function, line: #line)
    }

    fileprivate func observeLocationServices()
    {
        self.unobserveLocationServices()
        
        let queue = OperationQueue.main
        NotificationCenter.default
            .addObserver(forName: NSNotification.Name(rawValue: JFCore.Constants.Notification.locationUpdated), object: nil, queue: queue) {
                [weak self] (NSNotification) in
                guard let locs = LocationManager.instance.locations,
                    let f = locs.first,
                    let strong = self else {
                        return
                }
                strong.label.text = strong.locationDescription(f)
                strong.location = f
                strong.label.setAccessLabel()
                strong.reverseLocation(f)
        }
        
        NotificationCenter.default
            .addObserver(forName: NSNotification.Name(rawValue: JFCore.Constants.Notification.locationError), object: nil, queue: queue) {
                [weak self]
                note in
                if let _: Error = note.object as? Error,
                   let strong = self {
                    strong.locationRestart()
                }
        }
        
        NotificationCenter.default
            .addObserver(forName: NSNotification.Name(rawValue: JFCore.Constants.Notification.locationAuthorized), object: nil, queue: queue) {
                (NSNotification) in
                if !JFCore.LocationManager.instance.isAuthorized() {
                    // do nothing
                }
        }
    }
    
    func locationTitle(_ location : CLLocation) -> String {
        var aux : String = "["
        aux += "\(location.coordinate.latitude);"
        aux += "\(location.coordinate.longitude)"
        aux += "]"
        return aux
    }

    func locationDescription(_ location : CLLocation) -> String {
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
    
    
    func placemarkDescription(_ placemark : CLPlacemark) -> String {
        
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
        if let _isoCountryCode = placemark.isoCountryCode {
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
    
    fileprivate func logCurrentLanguage()
    {
        let locale = Locale.current
        for key in [NSLocale.Key.identifier, NSLocale.Key.languageCode, NSLocale.Key.countryCode, NSLocale.Key.scriptCode, NSLocale.Key.variantCode, NSLocale.Key.usesMetricSystem, NSLocale.Key.measurementSystem, NSLocale.Key.decimalSeparator] {
            if let name = (locale as NSLocale).object(forKey: key) {
                Analytics.logFunction(function: #function, parameters: [key.rawValue : name as AnyObject])
            }
        }
        if let calendar = (locale as NSLocale).object(forKey: NSLocale.Key.calendar) as? Calendar {
            Analytics.logFunction(function: #function, parameters: [NSLocale.Key.calendar.rawValue : calendar.identifier as AnyObject])
        }
    }

    
    func reverseLocation(_ location : CLLocation) {
        
        LocationManager.instance.reverseLocation(location: location, didFailWithError: { (jferror) in
            Analytics.logFatal(error:jferror)
            jferror.fatal()
        }) { [weak self] (placemarks) in
            guard let strong = self else { return }
            Analytics.logFunction(function: #function, parameters: ["location" : "\(placemarks.count)" as AnyObject])
            if let f = placemarks.first {
                strong.placemark.text = strong.placemarkDescription(f)
            }
            strong.placemark.setAccessLabel()
            strong.placemarks = placemarks
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list" {
            let vc:ListViewController = segue.destination as! ListViewController
            guard let ps = self.placemarks,
                      let l = self.location else {
                        return
            }
            vc.placemarks = ps
            vc.title = self.locationTitle(l)
        }
    }
    
}

