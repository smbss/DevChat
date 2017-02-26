//
//  DataService.swift
//  DevChat
//
//  Created by smbss on 22/02/2017.
//  Copyright © 2017 smbss  All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
        // Using properties for FBreferences and fuctions for saving data
    
    var mainRef: FIRDatabaseReference {
            // Returns the reference to this specific app database
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child("users")
    }
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("images")
    }
    
    var videosStorageRef: FIRStorageReference {
        return mainStorageRef.child("videos")
    }
    
    func saveUser(uid: String, email: String, pass: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName": "" as AnyObject, "lastName": "" as AnyObject, "email": email as AnyObject, "pass": pass as AnyObject]
            // Saving the profile Dictionary<String, AnyObject> to Firebase
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo: Dictionary<String, User>, mediaURL: URL) {
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
        }
        
        let pr: Dictionary<String, AnyObject> = [
            "mediaURL": mediaURL.absoluteString as AnyObject,
            "userID": senderUID as AnyObject,
            "openCount": 0 as AnyObject,
            "recipients": uids as AnyObject
        ]
        
            // Saving the pull request to the FirebaseDatabase
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
            // .childByAutoId() creates a new child with a unique ID
    }
}
