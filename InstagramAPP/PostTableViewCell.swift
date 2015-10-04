//
//  PostTableViewCell.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/09/30.
//  Copyright (c) 2015年 櫻本静香. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postData: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setPostImage()
        setUserImage()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostImage() {
        self.postImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.postImage.layer.cornerRadius = 5.0
        self.postImage.clipsToBounds = true
    }
    
    func setUserImage() {
        self.userImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.userImage.layer.cornerRadius = self.userImage.layer.bounds.width/2
        self.userImage.clipsToBounds = true
    }
    
    @IBAction func shareButton(sender: UIButton) {
    }
    @IBAction func commentButton(sender: UIButton) {
    }
    @IBAction func likeButton(sender: UIButton) {
    }
}
