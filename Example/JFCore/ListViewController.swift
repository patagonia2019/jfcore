//
//  ListViewController.swift
//  JFCore
//
//  Created by Javier Fuchs on 8/28/16.
//  Copyright © 2016 Mobile Patagonia. All rights reserved.
//

import Foundation
import CoreLocation
import JFCore

class ListViewController: BaseTableViewController {
    
    var placemarks : [CLPlacemark]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
    }

    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let p = placemarks {
            return p.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellIdentifier", for: indexPath as IndexPath)
        #if os(tvOS)
        cell.imageView?.adjustsImageWhenAncestorFocused = true
        #endif
        if let ps = placemarks,
            let tl = cell.textLabel,
            let dtl = cell.detailTextLabel {
            let p = ps[indexPath.row] as CLPlacemark
            #if os(tvOS)
            tl.font = UIFont.boldSystemFont(ofSize: 46)
            dtl.font = UIFont.boldSystemFont(ofSize: 36)
            #else
            tl.font = UIFont.boldSystemFont(ofSize: 16)
            #endif
            tl.text = p.locality
            dtl.text = p.country
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        #if os(tvOS)
        return 200
        #else
        return 66
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Analytics.logMemoryWarning(function: #function, line: #line)
    }
    
}



