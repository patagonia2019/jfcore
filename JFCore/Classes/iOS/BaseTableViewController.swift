//
//  BaseTableViewController.swift
//  Xoshem
//
//  Created by Javier Fuchs on 8/18/16.
//  Copyright © 2016 Mobile Patagonia. All rights reserved.
//

import UIKit

open class BaseTableViewController: UITableViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()        
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Analytics.logMemoryWarning(function: #function, line: #line)
    }
    
}

