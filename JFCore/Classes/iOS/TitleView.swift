//
//  TitleView.swift
//  Xoshem
//
//  Created by Javier Fuchs on 8/18/16.
//  Copyright © 2016 Mobile Patagonia. All rights reserved.
//

import UIKit

public class TitleView: UILabel {
    
    public init(appName: String,
         title: String?,
         frame: CGRect = CGRectMake(0, 0, 100, 50),
         font: UIFont = UIFont.boldSystemFontOfSize(20),
         textColor: UIColor = UIColor.whiteColor(),
         shadowColor: UIColor = UIColor.blackColor())
    {
        super.init(frame: frame)
        self.font = font
        self.textColor = textColor
        self.shadowColor = shadowColor
        self.shadowOffset = CGSize(width: 1, height: 1)
        self.text = appName
        if let _title = title {
            self.text = self.text! + " " + _title
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

