//
//  AuthService.swift
//  DevChat
//
//  Created by smbss on 22/02/2017.
//  Copyright © 2017 smbss All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService {
        // Creating an AuthService if there isn't one already
    private static let _instance = AuthService()
    
        // Setting a public getter
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errorCode == .errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                // Show error to user
                            } else {
                                    // Checking if the user was created with unique user ID
                                if user?.uid != nil {
                                        // Sign in
                                    FIRAuth.auth()?.signIn(withEmail: email, password: email, completion: { (user, error) in
                                        
                                        if error != nil {
                                            // Show error to user
                                        } else {
                                            // Successfully logged in
                                        }
                                        
                                    })
                                }
                            }
                            
                        })
                    }
                    
                } else {
                    // Handle all other auth errors
                }
            } else {
                // Successfully logged in
            }
            
        })
    }
    
}
