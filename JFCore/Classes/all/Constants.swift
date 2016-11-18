//
//  Constants.swift
//  Pods
//
//  Created by Javier Fuchs on 8/9/16.
//
//

import Foundation

public struct Constants {
    
//    static let app : String = Bundle.mainBundle().bundleIdentifier!.componentsSeparatedByString(".").last!

    struct CoreData {
        static let extensionFile = "momd"
    }

    static let minimumDistanceFilterInMeters = 60.0 // update every 200ft

    public struct Notification {
        
        public static let locationUpdated : String = "Constants.Notification.locationUpdated"
        
        public static let locationError : String = "Constants.Notification.locationError"
        
        public static let locationAuthorized : String = "Constants.Notification.locationAuthorized"
        
        public static let locationSaved : String = "Constants.Notification.locationSaved"

    }

    /// An enumeration to specify codes for error conditions.
    public enum ErrorCode: Int {
        case CDServerConnectionFailed = 101
        case CDUnpackingJSONFailed = 102
        case CDProcessingDataFailed = 103
        case CDFetchRequestFailed = 104
        case CDApplicationDirectoryMissing = 105
        case CDAddPersistentStoreWithType = 106
        case CDCreatePrivateQueueContext = 107
        case LocMgrNoPlaceMarksFound = 108
        case LocMgrNoLocationsDetected = 109
        case LocMgrAuthorizationFailed = 110
        case LocMgrDidFailWithError = 111
    }
}
