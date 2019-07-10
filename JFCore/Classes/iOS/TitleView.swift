//
//  TitleView.swift
//  Xoshem
//
//  Created by Javier Fuchs on 8/18/16.
//  Copyright © 2016 Mobile Patagonia. All rights reserved.
//

#if os(macOS)
import Cocoa
public class TitleView: NSTextField {
    
    public init(appName: String,
                title: String?,
                frame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 50)),
                font: NSFont = NSFont.boldSystemFont(ofSize: 20),
                textColor: UIColor = UIColor.white,
                shadowColor: UIColor = UIColor.black)
    {
        super.init(frame: frame)
        self.font = font
        self.textColor = textColor
        self.stringValue = appName
        if let _title = title {
            self.stringValue = self.stringValue + " " + _title
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
#else
import UIKit
public class TitleView: UILabel {
    
    public init(appName: String,
                title: String?,
                frame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 50)),
                font: UIFont = UIFont.boldSystemFont(ofSize: 20),
                textColor: UIColor = UIColor.white,
                shadowColor: UIColor = UIColor.black)
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
#endif

