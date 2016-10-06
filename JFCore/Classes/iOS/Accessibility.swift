//
//  Accessibility.swift
//  Pods
//
//  Created by Javier Fuchs on 8/27/16.
//
//

import Foundation
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
    public func setAccessWithLabel(labelString: String, labelComment: String, trait: UIAccessibilityTraits, hint: String?) {
        assert(labelString.characters.count > 0, "label is mandatory in Accessibility")
        self.accessibilityLabel = NSLocalizedString(labelString, comment: labelComment)
        self.accessibilityTraits = trait
        if let h = hint {
            self.accessibilityHint = NSLocalizedString(h, comment: Constants.hint)
        }
        self.isAccessibilityElement = true
    }
    
    /// Reset accessibility
    public func resetAccess() {
        self.accessibilityTraits = UIAccessibilityTraitNone
        self.isAccessibilityElement = false
    }
    
    /// disable
    public func accessDisable() {
        self.accessibilityTraits = UIAccessibilityTraitNotEnabled
    }
    
    /// tell accessibility about the frequence of the update
    public func accessUpdatesFrequently() {
        self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently
    }
    
    /// Accessibility header trait
    /// Receives a string and optional hint
    public func setAccessHeader(string: String, hint: String?) {
        setAccessWithLabel(string, labelComment: Constants.comment.label, trait: UIAccessibilityTraitHeader, hint: hint)
    }
    
    /// Accessibility header trait
    /// Receives only the string
    public func setAccessHeader(string: String) {
        setAccessHeader(string, hint: nil)
    }
    
    /// Accessibility image trait
    /// Receives a string and optional hint
    public func setAccessImage(string: String, hint: String?) {
        setAccessWithLabel(string, labelComment: Constants.comment.image, trait: UIAccessibilityTraitImage, hint: hint)
    }
    
    /// Accessibility image trait
    /// Receives only the string
    public func setAccessImage(string: String) {
        setAccessImage(string, hint: nil)
    }
    
    /// Accessibility button trait
    /// Receives a string and optional hint
    public func setAccessButton(string: String, hint: String?)  {
        setAccessWithLabel(string, labelComment: Constants.comment.image, trait: UIAccessibilityTraitButton, hint: hint)
    }
    
    /// Accessibility button trait
    /// Receives only the string
    public func setAccessButton(string: String) {
        setAccessButton(string, hint: nil)
    }
    
    /// Accessibility label trait
    /// Receives a string and optional hint
    public func setAccessLabel(string: String, hint: String?) {
        setAccessWithLabel(string, labelComment: Constants.comment.label, trait: UIAccessibilityTraitStaticText, hint: hint)
    }
    
    /// Accessibility label trait
    /// Receives only the string
    public func setAccessLabel(string: String) {
        setAccessLabel(string, hint: nil)
    }

    /// Accessibility link trait
    /// Receives a string and optional hint
    public func setAccessLink(string: String, hint: String?) {
        setAccessWithLabel(string, labelComment: Constants.comment.link, trait: UIAccessibilityTraitLink, hint: hint)
    }
    
    /// Accessibility label trait
    /// Receives only the string
    public func setAccessLink(string: String) {
        setAccessLabel(string, hint: nil)
    }
    
    /// Accessibility search trait
    /// Receives a string and optional hint
    public func setAccessSearch(string: String, hint: String?) {
        setAccessWithLabel(string, labelComment: Constants.comment.search, trait: UIAccessibilityTraitSearchField, hint: hint)
    }
    
    /// Accessibility search trait
    /// Receives only the string
    public func setAccessSearch(string: String) {
        setAccessLabel(string, hint: nil)
    }
    
    /// Accessibility media trait (video, stream)
    /// Receives a string and optional hint
    public func setAccessVideo(string: String, hint: String?) {
        setAccessWithLabel(string, labelComment: Constants.comment.media, trait: UIAccessibilityTraitStartsMediaSession, hint: hint)
    }
    
    /// Accessibility media trait
    /// Receives only the string
    public func setAccessVideo(string: String) {
        setAccessLabel(string, hint: nil)
    }
    
}

public extension UILabel {
    
    /// Accessibility label trait
    /// Uses what is in text
    public func setAccessLabel() {
        if let text = self.text {
            setAccessLabel(text, hint: nil)
        }
    }
}

