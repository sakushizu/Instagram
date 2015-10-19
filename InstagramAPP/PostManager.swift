//
//  PostManager.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/07.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

@objc protocol PostManagerDelegate {
    func didFinishedFetchPosts()
}

class PostManager: NSObject {
    static let sharedInstance = PostManager()
    var posts: [Post] = []
    weak var delegate: PostManagerDelegate?
    
    func fetchPosts(callback: () -> Void) {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.posts = []
                let posts = objects as [PFObject]!
                for object in posts! {
                    let text      = object["text"] as! String
                    let imageFile = object["image"] as! PFFile
                    let post = Post(text: text, image: nil)
                    post.objectId = object.objectId
                    imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if error == nil {
                            post.image = UIImage(data: imageData!)
                            self.delegate?.didFinishedFetchPosts()
                        }
                    })
                    
                    let userObject = object["user"] as! PFUser
                    let userName = userObject["username"] as! String
                    let userImageFile = userObject["image"] as! PFFile
                    let user = User(name: userName, password: "")
                    userImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if error == nil {
                            user.image = UIImage(data: imageData!)
                            self.delegate?.didFinishedFetchPosts()
                        }
                    })
                    post.user = user
                    self.posts.append(post)
                    callback()
                }
            }
        }
    }
    
}


