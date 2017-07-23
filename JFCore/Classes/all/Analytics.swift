//
//  Analytics.swift
//  Pods
//
//  Created by Javier Fuchs on 8/27/16.
//
//
import Foundation

public class Analytics : NSObject {
    
    private static let instance = Analytics()
    var selector : Selector?
    var target : AnyObject?
    
    struct Constants {
        static let maxLength = 100
        struct event {
            static let error = "error"
            static let fatal : String = "fatal"
            static let memwarning = "memwarning"
            static let normal = "normal"
            static let start = "start"
            static let stop = "stop"
        }
        struct field {
            static let date = "date"
            static let function = "function"
            static let line = "line"
        }
    }    
    
    private func logEvent(event: String, parameters: [String : AnyObject]?) {
        if let sel = selector,
           let tgt = target,
            let parameters = Analytics.createParameters(using: parameters)
        {
            _ = tgt.perform(sel, with: event, with: parameters)
        }
    }
    
    public class func configureWithAnalyticsTarget(target : AnyObject?, selector : Selector) {
        instance.target = target
        instance.selector = selector
    }

    public class func start() {
        instance.logEvent(event: Constants.event.start, parameters: [Constants.field.date: "\(NSDate())" as AnyObject])
    }
    
    public class func stop() {
        instance.logEvent(event: Constants.event.stop, parameters: [Constants.field.date: "\(NSDate())" as AnyObject])
    }
    
    public class func logFatal(error: JFError) {
        instance.logEvent(event: Constants.event.fatal, parameters: error.asDictionary())
    }
    
    public class func logError(error: JFError) {
        instance.logEvent(event: Constants.event.error, parameters: error.asDictionary())
    }
    
    public class func logFunction(function: String, parameters: [String : AnyObject]?) {
        var dict = [String : AnyObject]()
        if let param = parameters {
            for (k,v) in param {
                dict[k] = v
            }
        }
        instance.logEvent(event: Constants.event.normal, parameters:dict)
    }
    
    public class func logMemoryWarning(function: String, line: Int) {
        self.logFunction(function: Constants.event.memwarning, parameters: [
            Constants.field.function : function as AnyObject,
            Constants.field.line: "\(line)" as AnyObject])
    }
    
    
    private class func createParameters(using errorDictionary: [String : AnyObject]?) -> [String : AnyObject]? {
        var parameters = [String : AnyObject]()
        guard let errorDictionary = errorDictionary else {
            return parameters
        }
        print("[")
        for (k,v) in errorDictionary {
            let indexKey = k.index(k.startIndex,
                                   offsetBy: min(Constants.maxLength, k.characters.count))
            let key = k.substring(to: indexKey)
            if let string = v as? String {
                let indexValue = string.index(string.startIndex,
                                              offsetBy: min(Constants.maxLength, string.characters.count))
                let value = string.substring(to: indexValue)
                parameters[key] = value as AnyObject
                print("\(key) = \(value)")
            }
            else {
                print("\(key) = \(v)")
                parameters[key] = v
            }
            print("\n")
        }
        print("]")
        return parameters
    }
}
