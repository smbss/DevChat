//
//  PendingMessage.swift
//  DevChat
//
//  Created by smbss on 27/02/2017.
//  Copyright © 2017 smbss. All rights reserved.
//

import UIKit

struct PendingMessage {
    private var _mediaURL: String?
    private var _senderUID: String?
    private var _senderDisplayName: String?
    private var _openCount: Int?
    private var _dateCreated: String?
    private var _messageUID: String?
    private var _mediaType: String?
    
    var mediaURL: String? {
        return _mediaURL
    }
    
    var senderUID: String? {
        return _senderUID
    }
    
    var senderDisplayName: String? {
        return _senderDisplayName
    }
    
    var openCount: Int?{
        return _openCount
    }
    
    var dateCreated: String? {
        return _dateCreated
    }
    
    var messageUID: String? {
        return _messageUID
    }
    
    var mediaType: String? {
        return _mediaType
    }
    
    init(pendingMessageUID: String, pendingMessage: Dictionary<String, AnyObject>) {
        _mediaURL = pendingMessage["mediaURL"] as? String
        _senderUID = pendingMessage["senderUID"] as? String
        _senderDisplayName = pendingMessage["senderDisplayName"] as? String
        _openCount = pendingMessage["openCount"] as? Int
        _dateCreated = pendingMessage["dateCreated"] as? String
        _mediaType = pendingMessage["mediaType"] as? String
        _messageUID = pendingMessageUID
    }
    
}
