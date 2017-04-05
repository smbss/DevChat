//
//  AuthService.swift
//  DevChat
//
//  Created by smbss on 22/02/2017.
//  Copyright © 2017 smbss. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
        // Creating an AuthService if there isn't one already
    private static let _instance = AuthService()
    
        // Setting a public getter
    static var instance: AuthService {
        return _instance
    }
    
    var currentUserUID: String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                    // Error signing in the user for the first time
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errorCode == .errorCodeUserNotFound {
                            // Creating user account if there is none already
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                    // Error creating user
                                self.handleFirebase(error: error! as NSError, onComplete: onComplete)
                            } else {
                                    // Checking if the user was created with unique user ID
                                if user?.uid != nil {
                                        // Saving the user to the Database
                                    DataService.instance.saveUser(uid: user!.uid, email: email, pass: password)
                                    onComplete?(nil, user)
                                }
                            }
                        })
                    } else {
                            // Handle all other errors besides errorCodeUserNotFound
                        self.handleFirebase(error: error! as NSError, onComplete: onComplete)
                    }
                } else {
                        // Could not create errorCode
                    self.handleFirebase(error: error! as NSError, onComplete: onComplete)
                }
            } else {
                    // Successfully logged in existing user
                onComplete?(nil, user)
            }
        })
    }
    
    func handleFirebase(error: NSError, onComplete: Completion?) {
            // In this specific case it's not relevant to deal with different kind of errors
            // The user either is logged in, or if it doesn't exist we create it automatically on login()
            // Other errors are presented to the user through the completion block below
        onComplete?(error.localizedDescription, nil)
    }
}
