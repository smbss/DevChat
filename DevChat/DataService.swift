//
//  DataService.swift
//  DevChat
//
//  Created by smbss on 22/02/2017.
//  Copyright © 2017 smbss.  All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
            // Returns the reference to this specific app database
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child("users")
    }
    
    var userPendingMessagesRef: FIRDatabaseReference {
        return usersRef.child(AuthService.instance.currentUserUID).child("pendingMessages")
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
        let profile: Dictionary<String, AnyObject> = ["email": email as AnyObject, "pass": pass as AnyObject]
            // Saving the profile Dictionary<String, AnyObject> to Firebase
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
    
    func sendMediaPullRequest(sender: User, sendingTo: Dictionary<String, User>, mediaURL: URL, mediaType: String) {
        let senderUID = sender.uid
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateCreated = dateFormatter.string(from: Date())
        let messageUID = "\(dateCreated)-user-\(senderUID)"
        
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
        }
        
        let pendingMessage: Dictionary<String, AnyObject> = [
            "mediaURL": mediaURL.absoluteString as AnyObject,
            "senderUID": senderUID as AnyObject,
            "senderDisplayName": sender.displayName as AnyObject,
            "openCount": 0 as AnyObject,
            "dateCreated": dateCreated as AnyObject,
            "messageUID": messageUID as AnyObject,
            "mediaType": mediaType as AnyObject
        ]
        
        for uid in uids {
            mainRef.child("users").child(uid).child("pendingMessages").child(messageUID).setValue(pendingMessage)
        }
        
            // Creating the dict that will save the receipients that already opened the message to notify the sender
            // TO-DO: Needs implementation from the sender side (PendingMessagesVC)
        let pullRequest: Dictionary<String, AnyObject> = [
            "mediaURL": mediaURL.absoluteString as AnyObject,
            "uncheckedReceivers": uids as AnyObject
        ]
        
            // Saving the pull request to the FirebaseDatabase
        mainRef.child("pullRequests").child(messageUID).setValue(pullRequest)
    }
}
