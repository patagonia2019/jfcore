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
    
    /// Show an alert with message an error.
    func showAlert(title: String? = nil, message: String? = nil, error: JFError? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title ?? error?.title(), message: message ?? error?.message(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
