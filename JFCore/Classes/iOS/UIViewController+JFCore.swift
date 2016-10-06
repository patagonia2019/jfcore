//
//  UIViewController+JFCore.swift
//  Pods
//
//  Created by Javier Fuchs on 8/28/16.
//
//

import Foundation
public extension UIViewController {
    
    internal func titleView() -> TitleView {
        return TitleView(appName: Common.app, title: self.title)
    }

}
