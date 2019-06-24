//
//  ListController.swift
//  Watch Extension
//
//  Created by fox on 23/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import WatchKit
import Foundation

class ListController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    var placemarks : [CLPlacemark]?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        loadItems()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
    }
    
    func loadItems() {
        // Configure the table object and get the row controllers.
        table.setNumberOfRows(placemarks?.count ?? 0, withRowType: "TableViewCellIdentifier")
        
        // Iterate over the rows and set the label and image for each one.
        for i in 0..<table.numberOfRows {
            // Set the values for the row controller
            guard let row = table.rowController(at: i) as? MyRowController,
                let ps = placemarks else { continue }
            let p = ps[i] as CLPlacemark

            row.itemLabel.setText(p.locality)
            row.itemDescription.setText(p.country)
        }
    }

}

class MyRowController: WKInterfaceGroup {
    @IBOutlet weak var itemLabel: WKInterfaceLabel!
    @IBOutlet weak var itemDescription: WKInterfaceLabel!
}

