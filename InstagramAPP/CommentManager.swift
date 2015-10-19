//
//  CommentManager.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/17.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

@objc protocol CommentManagerDelegate {
    func didFinishedFetchComments()
}

class CommentManager: NSObject {
    
    static let sharedInstance = CommentManager()
    var comments: [Comment] = []
    weak var delegate: CommentManagerDelegate?
    
    func fetchComments(post: Post, callback: () -> Void) {
        let commentQuery = PFQuery(className: "Comment")
        commentQuery.whereKey("postId", equalTo: post.objectId)
        commentQuery.orderByDescending("createdAt")
        commentQuery.includeKey("user")
        commentQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.comments = []
                if objects!.count > 0 {
                    for object in (objects! as [PFObject]) {
                        let text = object["text"] as! String
                        let postId = object["postId"] as! String
                        let comment = Comment(text: text, postId: postId)
                        
                        let userObject = object["user"] as! PFUser
                        let userName = userObject["username"] as! String
                        let userImageFile = userObject["image"] as! PFFile
                        let user = User(name: userName, password: "")
                        userImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                            if error == nil {
                                user.image = UIImage(data: imageData!)
                                self.delegate?.didFinishedFetchComments()
                            }
                        })
                        comment.user = user
                        self.comments.append(comment)
                        callback()
                    }
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
}

