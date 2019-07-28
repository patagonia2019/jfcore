//
//  Accessibility.swift
//  Pods
//
//  Created by Javier Fuchs on 8/27/16.
//
//

#if !os(macOS)
import Foundation
import UIKit
public extension NSObject {
    
    struct Constants {
        static let hint = "Accessibility Hint"
        struct comment {
            static let button = "Accessibility Button"
            static let image = "Accessibility Image"
            static let link = "Accessibility Link"
            static let label = "Accessibility Label"
            static let media = "Accessibility Media / Video"
            static let search = "Accessibility Search"
        }
    }
    
    /// Accessibility in general
    /// Configures the accessibility for all the elements
    /// Receives a labelString (mandatory), labelComment, trait and optional hint
    func setAccessWithLabel(labelString: String, labelComment: String, trait: UIAccessibilityTraits, hint: String?) {
        assert(labelString.count > 0, "label is mandatory in Accessibility")
        self.accessibilityLabel = NSLocalizedString(labelString, comment: labelComment)
        self.accessibilityTraits = trait
        if let h = hint {
            self.accessibilityHint = NSLocalizedString(h, comment: Constants.hint)
        }
        self.isAccessibilityElement = true
    }
    
    /// Reset accessibility
    
    func resetAccess() {
        self.accessibilityTraits = UIAccessibilityTraits.none
        self.isAccessibilityElement = false
    }
    
    /// disable
    func accessDisable() {
        self.accessibilityTraits = UIAccessibilityTraits.notEnabled
    }
    
    /// tell accessibility about the frequence of the update
    func accessUpdatesFrequently() {
        self.accessibilityTraits = UIAccessibilityTraits.updatesFrequently
    }
    
    /// Accessibility header trait
    /// Receives a string and optional hint
    func setAccessHeader(string: String, hint: String?) {
        setAccessWithLabel(labelString: string, labelComment: Constants.comment.label, trait: UIAccessibilityTraits.header, hint: hint)
    }
    
    /// Accessibility header trait
    /// Receives only the string
    func setAccessHeader(string: String) {
        setAccessHeader(string: string, hint: nil)
    }
    
    /// Accessibility image trait
    /// Receives a string and optional hint
    func setAccessImage(string: String, hint: String?) {
        setAccessWithLabel(labelString: string, labelComment: Constants.comment.image, trait: UIAccessibilityTraits.image, hint: hint)
    }
    
    /// Accessibility image trait
    /// Receives only the string
    func setAccessImage(string: String) {
        setAccessImage(string: string, hint: nil)
    }
    
    /// Accessibility button trait
    /// Receives a string and optional hint
    func setAccessButton(string: String, hint: String?)  {
        setAccessWithLabel(labelString: string, labelComment: Constants.comment.image, trait: UIAccessibilityTraits.button, hint: hint)
    }
    
    /// Accessibility button trait
    /// Receives only the string
    func setAccessButton(string: String) {
        setAccessButton(string: string, hint: nil)
    }
    
    /// Accessibility label trait
    /// Receives a string and optional hint
    func setAccessLabel(string: String, hint: String?) {
        setAccessWithLabel(labelString: string, labelComment: Constants.comment.label, trait: UIAccessibilityTraits.staticText, hint: hint)
    }
    
    /// Accessibility label trait
    /// Receives only the string
    func setAccessLabel(string: String) {
        setAccessLabel(string: string, hint: nil)
    }

    /// Accessibility link trait
    /// Receives a string and optional hint
    func setAccessLink(string: String, hint: String?) {
        setAccessWithLabel(labelString: string, labelComment: Constants.comment.link, trait: UIAccessibilityTraits.link, hint: hint)
    }
    
    /// Accessibility label trait
    /// Receives only the string
    func setAccessLink(string: String) {
        setAccessLabel(string: string, hint: nil)
    }
    
    /// Accessibility search trait
    /// Receives a string and optional hint
    func setAccessSearch(string: String, hint: String?) {
        setAccessWithLabel(labelString: string, labelComment: Constants.comment.search, trait: UIAccessibilityTraits.searchField, hint: hint)
    }
    
    /// Accessibility search trait
    /// Receives only the string
    func setAccessSearch(string: String) {
        setAccessLabel(string: string, hint: nil)
    }
    
    /// Accessibility media trait (video, stream)
    /// Receives a string and optional hint
    func setAccessVideo(string: String, hint: String?) {
        setAccessWithLabel(labelString: string, labelComment: Constants.comment.media, trait: UIAccessibilityTraits.startsMediaSession, hint: hint)
    }
    
    /// Accessibility media trait
    /// Receives only the string
    func setAccessVideo(string: String) {
        setAccessLabel(string: string, hint: nil)
    }
}

public extension UILabel {
    
    /// Accessibility label trait
    /// Uses what is in text
    func setAccessLabel() {
        if let text = self.text {
            setAccessLabel(string: text)
        }
    }
}

#endif
