//
//  BaseViewController.swift
//  Xoshem
//
//  Created by Javier Fuchs on 8/18/16.
//  Copyright © 2016 Mobile Patagonia. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

open class BaseViewController: UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        #if os(iOS)
        navigationItem.backBarButtonItem?.tintColor = .white
        #endif

        self.logCurrentLanguage()
    }

    #if !os(macOS)
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Analytics.logMemoryWarning(function: #function, line: #line)
    }
    #endif

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

}

