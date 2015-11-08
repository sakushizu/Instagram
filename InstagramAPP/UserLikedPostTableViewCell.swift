//
//  userLikedPostTableViewCell.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/11/02.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit

class UserLikedPostTableViewCell: UITableViewCell {

    @IBOutlet weak var userImgeView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
