//
//  CoreDataManager.swift
//  JFCore
//
//  Created by Javier Fuchs on 7/12/16.
//
//

import Foundation
import CoreData


public class CoreDataManager {
    // MARK: Properties
    
    public static let instance = CoreDataManager()
    
    /// The managed object model for the application.
    lazy var managedObjectModel: NSManagedObjectModel = {
        /*
         This property is not optional. It is a fatal error for the application
         not to be able to find and load its model.
         */
        let bundleName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String

        let modelURL = Bundle.main.url(forResource: bundleName, withExtension: JFCore.Constants.CoreData.extensionFile)!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    /// The directory the application uses to store the Core Data store file.
    lazy var applicationSupportDirectory: NSURL = {
        let fileManager = FileManager.default
        
        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        let applicationSupportDirectoryURL = urls.last!
        
        let bundleID = Bundle.main.bundleIdentifier

        let applicationSupportDirectory = applicationSupportDirectoryURL.appendingPathComponent(bundleID!)
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: applicationSupportDirectory.absoluteString, isDirectory:&isDir) {
            if isDir.boolValue == false {
                let description = NSLocalizedString("Could not access the application data folder.",
                                                    comment: "Failed to initialize applicationSupportDirectory.")
                
                let reason = NSLocalizedString("Found a file in its place.",
                                               comment: "Failed to initialize applicationSupportDirectory.")
                
                let myerror = JFError(code: JFCore.Constants.ErrorCode.CDApplicationDirectoryMissing.rawValue, desc: description,
                                    reason: reason, suggestion: "\(#file):\(#line):\(#column):\(#function)",
                    underError: nil)
                
                myerror.fatal()
            }
            else {
                let e = JFError(code: NSFileReadNoSuchFileError, desc: "could not read file",
                              reason: "no such file", suggestion: "\(#file):\(#line):\(#column):\(#function)", underError: nil)
                e.fatal()
            }
        }
        else {
            let path = applicationSupportDirectory.path
            
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories:true, attributes:nil)
            }
            catch {
                let e = JFError(code: NSFileReadNoSuchFileError,
                              desc: "Could not create application documents directory at \(path).",
                    reason: "some permissions issues",
                    suggestion: "\(#file):\(#line):\(#column):\(#function)",
                    underError: error as NSError)
                e.fatal()
            }

        }
        
        return applicationSupportDirectory as NSURL
    }()
    
    /// URL for the main Core Data store file.
    lazy var storeURL: NSURL = {
        let bundleID = Bundle.main.bundleIdentifier
        return self.applicationSupportDirectory.appendingPathComponent(bundleID!)! as NSURL
    }()
    
    
    // Creates a new Core Data stack and returns a managed object context associated with a private queue.
    public func createPrivateQueueContext() throws -> NSManagedObjectContext {
        
        // Uses the same store and model, but a new persistent store coordinator and context.
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        /*
         Attempting to add a persistent store may yield an error--pass it out of
         the function for the caller to deal with.
         */
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil,
                                           at: self.storeURL as URL, options: options)
    
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        context.performAndWait() {
            
            context.persistentStoreCoordinator = coordinator
            
            // Avoid using default merge policy in multi-threading environment:
            // when we delete (and save) a record in one context,
            // and try to save edits on the same record in the other context before merging the changes,
            // an exception will be thrown because Core Data by default uses NSErrorMergePolicy.
            // Setting a reasonable mergePolicy is a good practice to avoid that kind of exception.
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            // In OS X, a context provides an undo manager by default
            // Disable it for performance benefit
            context.undoManager = nil
        }
        
        return context
    }
    
    public var taskContext: NSManagedObjectContext {
        if _taskContext != nil {
            return _taskContext!
        }
        
        do {
            _taskContext = try self.createPrivateQueueContext()
        } catch {
            // Report any error we got.
            let e = JFError(code: JFCore.Constants.ErrorCode.CDCreatePrivateQueueContext.rawValue,
                          desc: "Could not process taksContext data",
                          reason: "Failed to initialize the application's saved data",
                          suggestion: "\(#file):\(#line):\(#column):\(#function)",
                          underError: error as NSError)
            e.fatal()
        }
        
        return _taskContext!
    }
    var _taskContext: NSManagedObjectContext? = nil
    
    public func save() {
        if let mco: NSManagedObjectContext = self.taskContext
        {
            do {
                try mco.save()
            }
            catch {
                print("Error: \(error)\nCould not save Core Data context.")
                return
            }
//            mco.reset()
        }
    }

    public func rollback() {
        if let mco: NSManagedObjectContext = self.taskContext
        {
            mco.rollback()
            mco.reset()
        }
    }

}
