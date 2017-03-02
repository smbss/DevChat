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
    
    func login(email: String, password: String, onComplete: Completion?) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            print("AuthService.login user: \(user) AuthService.error: \(error) " )
            if error != nil {
                    // Error signing in the user for the first time
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    print("Error Code: \(errorCode.rawValue)")
                    if errorCode == .errorCodeUserNotFound {
                            // Creating user account if there is none already
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            print("AuthService.login.createUser user: \(user) AuthService.error: \(error) " )
                            if error != nil {
                                    // Error creating user
                                self.handleFirebase(error: error as! NSError, onComplete: onComplete)
                            } else {
                                    // Checking if the user was created with unique user ID
                                if user?.uid != nil {
                                    print("Successfully created user UID: \(user?.uid)")
                                    print("Current User UID (Created): \(FIRAuth.auth()?.currentUser?.uid)")
                                        // Saving the user to the Database
                                    DataService.instance.saveUser(uid: user!.uid, email: email, pass: password)
                                    onComplete?(nil, user)
                                }
                            }
                        })
                    } else {
                            // Handle all other errors besides errorCodeUserNotFound
                        self.handleFirebase(error: error as! NSError, onComplete: onComplete)
                    }
                } else {
                        // Could not create errorCode
                    self.handleFirebase(error: error as! NSError, onComplete: onComplete)
                }
            } else {
                    // Successfully logged in existing user
                print("Successfully logged in existing user UID: \(FIRAuth.auth()?.currentUser?.uid)")
                onComplete?(nil, user)
            }
        })
    }
    
    func handleFirebase(error: NSError, onComplete: Completion?) {
        onComplete?(error.localizedDescription, nil)
        
//        if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
//            print("ErrorCode: \(errorCode)")
//            switch (errorCode) {
//            case .errorCodeInvalidEmail:
//                print(".errorCodeInvalidEmail")
//                onComplete?(error.localizedDescription, nil)
//                break
//            case .errorCodeWrongPassword:
//                print(".errorCodeWrongPassword")
//                onComplete?(error.localizedDescription, nil)
//                break
//            case .errorCodeUserNotFound:
//                print(".errorCodeUserNotFound")
//                break
//            default:
//                print("Default Error")
//                onComplete?(error.localizedDescription, nil)
//                break
//            }
//        } else {
//                // Could not create errorCode
//            onComplete?(error.localizedDescription, nil)
//        }
    }
}
