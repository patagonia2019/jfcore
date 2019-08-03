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
    lazy var managedObjectModel: NSManagedObjectModel? = {
        /*
         This property is not optional. It is a fatal error for the application
         not to be able to find and load its model.
         */
        guard let bundleName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String else {
            return nil
        }

        guard let modelURL = Bundle.main.url(forResource: bundleName, withExtension: JFCore.Constants.CoreData.extensionFile) else {
            return nil
        }
        
        return NSManagedObjectModel(contentsOf: modelURL)
    }()
    
    /// The directory the application uses to store the Core Data store file.
    lazy var applicationSupportDirectory: URL = {
        let fileManager = FileManager.default
        
        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        guard let applicationSupportDirectoryURL = urls.last else { fatalError() }
        
        guard let bundleID = Bundle.main.bundleIdentifier else { fatalError() }

        let applicationSupportDirectory = applicationSupportDirectoryURL.appendingPathComponent(bundleID)
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: applicationSupportDirectory.absoluteString, isDirectory:&isDir),
            isDir.boolValue == false
        {
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
        
        return applicationSupportDirectory
    }()
        
    lazy var storeURL: URL? = {
        guard let bundleID = Bundle.main.bundleIdentifier else { fatalError() }
        guard let info = Bundle.main.infoDictionary,
            let bundleShortVersion = info["CFBundleShortVersionString"] as? String,
            let bundleVersion = info["CFBundleVersion"] as? String
        else {
            fatalError()
        }
        return applicationSupportDirectory.appendingPathComponent(bundleID + "\(bundleShortVersion).\(bundleVersion)" + ".sqlite3")
    }()
    
    // Creates a new Core Data stack and returns a managed object context associated with a private queue.
    public func createPrivateQueueContext() throws -> NSManagedObjectContext {
        
        // Uses the same store and model, but a new persistent store coordinator and context.
        guard let managedObjectModel = managedObjectModel else { fatalError() }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        /*
         Attempting to add a persistent store may yield an error--pass it out of
         the function for the caller to deal with.
         */
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        if let sqlitePreExistent = Bundle.main.path(forResource: Bundle.main.bundleIdentifier, ofType: "sqlite3"),
            let sqliteInDocument = storeURL?.path,
            FileManager.default.fileExists(atPath: sqlitePreExistent) && !FileManager.default.fileExists(atPath: sqliteInDocument) {
                try FileManager.default.copyItem(atPath: sqlitePreExistent, toPath: sqliteInDocument)
            }
            
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil,
                                           at: storeURL, options: options)
    
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
    
    
    public lazy var taskContext : NSManagedObjectContext? = {
        do {
            return try createPrivateQueueContext()
            
        } catch {
            fatalError("fatal: No context \(error)")
        }
    }()

    public func save() {
        do {
            try taskContext?.save()
        }
        catch {
            fatalError("Error: Could not save Core Data context \(error)")
        }
    }
    
    public func rollback() {
        taskContext?.rollback()
        taskContext?.reset()
    }

}
