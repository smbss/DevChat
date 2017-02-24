//
//  DataService.swift
//  DevChat
//
//  Created by smbss on 22/02/2017.
//  Copyright © 2017 smbss  All rights reserved.
//

import Foundation
import FirebaseDatabase

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
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName": "" as AnyObject, "lastName": "" as AnyObject]
            // Saving the profile Dictionary<String, AnyObject> to Firebase
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
}
