//
//  Error.swift
//  Pods
//
//  Created by Javier Fuchs on 7/26/16.
//
//

import Foundation

public class JFError : Error {
    
    public var error: NSError?
    
    public init(code: Int, desc: String?, reason: String?, suggestion: String?, path: String? = nil, line: String? = nil, url: String? = nil, underError error: NSError?) {
        var dict = [String: AnyObject]()
        if let adesc = desc {
            dict[NSLocalizedDescriptionKey] = adesc as AnyObject?
        }
        if let areason = reason {
            dict[NSLocalizedFailureReasonErrorKey] = areason as AnyObject?
        }
        
        if let asuggestion = suggestion {
            dict[NSLocalizedRecoverySuggestionErrorKey] = asuggestion as AnyObject?
        }
        if let aerror = error {
            dict[NSUnderlyingErrorKey] = aerror
        }
        if let path = path {
            dict[NSFilePathErrorKey] = path as AnyObject
        }
        if let url = url {
            dict[NSURLErrorKey] = url as AnyObject
        }
        if let line = line {
            dict["NSFilePathLineKey"] = line as AnyObject
        }
        self.error = NSError(domain: Bundle.main.bundleIdentifier!, code:code, userInfo: dict)
    }
    
    public init(_ error: NSError?) {
        if let e = error {
            self.error = e
        }
    }
    
    public func title() -> String {
        if let e = self.error {
            return e.localizedDescription
        }
        return ""
    }
    
    public func reason() -> String {
        if let e = self.error,
           let reason = e.localizedFailureReason {
            return reason
        }
        return ""
    }
    
    public func asDictionary() -> [String : AnyObject]? {
        if let error = self.error {
            var dict = [String : AnyObject]()
            dict["code"] = error.code as AnyObject
            let ld = error.localizedDescription
            if ld.characters.count > 0 {
                dict[NSLocalizedDescriptionKey] = ld as AnyObject
            }
            if let lfr = error.localizedFailureReason {
                dict[NSLocalizedFailureReasonErrorKey] = lfr as AnyObject
            }
            if let lrs = error.localizedRecoverySuggestion {
                dict[NSLocalizedRecoverySuggestionErrorKey] = lrs as AnyObject
            }
            if let lro = error.localizedRecoveryOptions {
                dict[NSLocalizedRecoveryOptionsErrorKey] = lro as AnyObject
            }
            let domain = error.domain
            if domain.characters.count > 0 {
                dict[NSCocoaErrorDomain] = domain as AnyObject
            }            
            return dict
        }
        return nil
    }

    public var debugDescription : String {
        var aux : String = "["
        if let _error = self.error {
            aux += "\(_error.code);"
            aux += "\(_error.localizedDescription);"
            if let _failureReason = _error.localizedFailureReason {
                aux += "\(_failureReason);"
            } else { aux += "();" }
            if let _recoverySuggestion = _error.localizedRecoverySuggestion {
                aux += "\(_recoverySuggestion);"
            } else { aux += "();" }
            aux += "\(_error.userInfo.description);"
        }
        aux += "]"
        return aux
    }
 
    public var description : String {
        var aux : String = "Error: "
        if let _error = self.error {
            aux += "code=\(_error.code). "
            aux += "\(_error.localizedDescription)\n"
        }
        aux += "Please contact us claiming this error."
        return aux
    }

    
    public func fatal() {
        fatalError("fatal:\(self.debugDescription)")
    }

}
