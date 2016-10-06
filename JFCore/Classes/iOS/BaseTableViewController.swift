//
//  BaseTableViewController.swift
//  Xoshem
//
//  Created by Javier Fuchs on 8/18/16.
//  Copyright © 2016 Mobile Patagonia. All rights reserved.
//

import UIKit

public class BaseTableViewController: UITableViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()        
        self.navigationItem.titleView = TitleView(appName: Common.app, title: self.title)
        self.title = ""
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Analytics.logMemoryWarning(#function, line: #line)
    }
    
}

