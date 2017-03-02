//
//  User.swift
//  DevChat
//
//  Created by smbss. on 25/02/2017.
//  Copyright © 2017 smbss All rights reserved.
//

import UIKit

struct User {
    private var _uid: String
    private var _displayName: String

    var uid: String {
        return _uid
    }
    
    var displayName: String {
        return _displayName
    }
    
    init(uid: String, displayName: String) {
        _uid = uid
        _displayName = displayName
    }
    
}
