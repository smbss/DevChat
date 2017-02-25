//
//  UserCell.swift
//  DevChat
//
//  Created by Sandro Simes on 25/02/2017.
//  Copyright © 2017 Cappsule. All rights reserved.
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
        let imageStr = selected ? "messageindicatorchecked1" : "messageindicator1"
        self.accessoryView = UIImageView(image: UIImage(named: imageStr))
    }
    
    func updateUI(user: User) {
        displayName.text = user.displayName
    }

}
