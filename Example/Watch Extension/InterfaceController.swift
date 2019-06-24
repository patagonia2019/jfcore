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
    var placemarks : [CLPlacemark]?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        image.setImage(UIImage.init(named: "background"))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
