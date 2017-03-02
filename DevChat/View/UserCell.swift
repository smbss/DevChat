//
//  UserCell.swift
//  DevChat
//
//  Created by smbss on 25/02/2017.
//  Copyright © 2017 smbss. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var displayName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
            // Initialization code
        setCheckmark(selected: false)
    }
    
    func setCheckmark(selected: Bool) {
        let imageStr = selected ? "checked3" : "unchecked3"
        let checkboxView = UIImageView(image: UIImage(named: imageStr))
        checkboxView.contentMode = .scaleAspectFit
        checkboxView.frame.size = CGSize(width: 30, height: 30)
        self.accessoryView = checkboxView
    }
    
    func updateUI(user: User) {
        displayName.text = user.displayName
    }

}
