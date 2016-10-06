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
           let tgt = target {
            tgt.performSelector(sel, withObject: event, withObject: parameters)
        }
    }
    
    public class func configureWithAnalyticsTarget(target : AnyObject?, selector : Selector) {
        instance.target = target
        instance.selector = selector
    }

    public class func start() {
        instance.logEvent(Constants.event.start, parameters: [Constants.field.date: "\(NSDate())"])
    }
    
    public class func stop() {
        instance.logEvent(Constants.event.stop, parameters: [Constants.field.date: "\(NSDate())"])
    }
    
    public class func logFatal(error: Error) {
        instance.logEvent(Constants.event.error, parameters: error.asDictionary())
    }
    
    public class func logError(error: Error) {
        instance.logEvent(Constants.event.error, parameters: error.asDictionary())
    }
    
    public class func logFunction(function: String, parameters: [String : AnyObject]?) {
        var dict = [String : AnyObject]()
        if let param = parameters {
            for (k,v) in param {
                dict[k] = v
            }
        }
        dict[Constants.field.function] = function
        
        instance.logEvent(Constants.event.normal, parameters:dict)
    }
    
    public class func logMemoryWarning(function: String, line: Int) {
        self.logFunction(Constants.event.memwarning, parameters: [
            Constants.field.function : function,
            Constants.field.line: "\(line)"])
    }
}
