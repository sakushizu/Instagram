//
//  PostTableViewCell.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/09/30.
//  Copyright (c) 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

@objc protocol PostTableViewCellDelegate {
    func tappedCommentButton(post: Post)
    func tappedShareButton(post: Post)
    func reloadData()
}


class PostTableViewCell: UITableViewCell {
    
    var post: Post!
    
    let currentUser = CurrentUser.sharedInstance
    
    weak var customDelegate:PostTableViewCellDelegate?

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postData: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var likesNumLabel: UILabel!
    @IBOutlet weak var likeButton: SpringButton!
    
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
        self.postImage.layer.cornerRadius = 5.0
        self.postImage.clipsToBounds = true
    }
    
    func setUserImage() {
        self.userImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.userImage.layer.cornerRadius = self.userImage.layer.bounds.width/2
        self.userImage.clipsToBounds = true
    }
    
    @IBAction func shareButton(sender: UIButton) {
        customDelegate?.tappedShareButton(post)
    }
    
    @IBAction func commentButton(sender: UIButton) {
        customDelegate?.tappedCommentButton(post)
    }
    @IBAction func tappedLikeBtn(sender: SpringButton) {
        sender.animation = "pop"
        sender.curve = "linear"
        sender.animate()
        sender.enabled = false
        let like = Like(user: PFUser.currentUser()!, post: post)
        like.save { () in
            sender.enabled = true
            self.customDelegate?.reloadData()
        }
    }
    
//    @IBAction func tappedLikeButton(sender: UIButton) {
//        sender.enabled = false
//        let like = Like(user: PFUser.currentUser()!, post: post)
//        like.save { () in
//            sender.enabled = true
//            self.customDelegate?.reloadData()
//        }
//    }
    
//    func confirmUserLiked() -> Bool {
//        let userIds = post.likedUserArray.map({(user: User) -> String in
//            return user.objectId!
//        })
//        if userIds.indexOf(currentUser.user.objectId!) == nil {
//            return false
//        } else {
//            return true
//        }
//    }
    
//    func changeLikeImageAsynchronous(button: UIButton) {
//        if button.currentImage! == UIImage(named: "Hearts Filled-50.png") {
//            let image = UIImage(named: "Hearts-50.png")
//            button.setImage(image, forState: .Normal)
//        } else  {
//            let image = UIImage(named: "Hearts Filled-50.png")
//            button.setImage(image, forState: .Normal)
//        }
//    }
    
    func changeLikeImage(currentUserLiked: Bool) {
        if currentUserLiked {
            let image = UIImage(named: "Hearts Filled-50.png")
            likeButton.setImage(image, forState: .Normal)
        } else {
            let image = UIImage(named: "Hearts-50.png")
            likeButton.setImage(image, forState: .Normal)
        }
    }
}
