//
//  UserPostTableViewCell.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/11/01.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
