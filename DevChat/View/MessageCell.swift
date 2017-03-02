//
//  MessageCell.swift
//  DevChat
//
//  Created by smbss on 27/02/2017.
//  Copyright © 2017 smbss. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    
    var mediaType: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(pendingMessage: PendingMessage) {
        self.mediaType = pendingMessage.mediaType
        var imageStr = String()
        switch (pendingMessage.mediaType, pendingMessage.openCount) {
        case (.some("video"),.some(Int.min ... 0)):
            imageStr = "checked1"
        case (.some("video"),.some(1 ... Int.max)):
            imageStr = "unchecked1"
        case (.some("image"),.some(Int.min ... 0)):
            imageStr = "checked2"
        case (.some("image"), .some(1 ... Int.max)):
            imageStr = "unchecked2"
        default:
            messageIcon.isHidden = true
        }
        if !messageIcon.isHidden {
            messageIcon.image = UIImage(named: imageStr)
        }
        displayName.text = pendingMessage.senderDisplayName
    }

}
