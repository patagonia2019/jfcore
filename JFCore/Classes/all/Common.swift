//
//  Common.swift
//  JFCore
//
//  Created by Javier Fuchs on 5/25/16.
//  Copyright Â© 2016 fuchs. All rights reserved.
//

import Foundation
import UIKit

public class Common {

    public static var app : String = {
        guard let info = NSBundle.mainBundle().infoDictionary,
            let bundleName = info["CFBundleName"] as? String else {
                return ""
        }
        return bundleName
    }()

    public class func synchronized(syncBlock:() -> Void) {
        objc_sync_enter(self)
        let lockQueue = dispatch_queue_create(NSBundle.mainBundle().bundleIdentifier!, nil)
        dispatch_sync(lockQueue) {
            syncBlock()
        }
        objc_sync_exit(self)
    }
    
    public class func randomColor() -> UIColor {
        let red = CGFloat(arc4random() % 255) / 255
        let green = CGFloat(arc4random() % 255) / 255
        let blue = CGFloat(arc4random() % 255) / 255
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
}
