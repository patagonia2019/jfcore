//
//  UIViewController+JFCore.swift
//  Pods
//
//  Created by Javier Fuchs on 8/28/16.
//
//

import Foundation
#if os(macOS)
import Cocoa
public typealias UIViewController = NSViewController
#else
import UIKit
#endif
public extension UIViewController {
    internal func titleView() -> TitleView {
        return TitleView(appName: Common.app, title: self.title)
    }
}
