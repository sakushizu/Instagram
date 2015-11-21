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
//                self.posts = []
                var tmpPosts: [Post] = []
                let posts = objects as [PFObject]!
                for object in posts! {
                    let objectId = object.objectId!
                    let text = object["text"] as! String
                    let imageFile = object["image"] as! PFFile
                    let post = Post(objectId: objectId, text: text, image: nil)
//                    post.objectId = object.objectId
                    
                    
                    imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if error == nil {
                            post.image = UIImage(data: imageData!)
//                            self.delegate?.didFinishedFetchPosts()
                        }
                    })
                    post.createdAt = object.createdAt
                    let userObject = object["user"] as! PFUser
                    let userName = userObject["username"] as! String
                    let userImageFile = userObject["image"] as! PFFile
                    let user = User(name: userName, password: "")
                    userImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if error == nil {
                            user.image = UIImage(data: imageData!)
//                            self.delegate?.didFinishedFetchPosts()
                        }
                        callback()
                    })
                    post.user = user
                    tmpPosts.append(post)
                    
                    //postにlikeしたusersの取得
                    let usersArray = object.relationForKey("likedUser")
                    usersArray.query()?.findObjectsInBackgroundWithBlock({ (usersArray: [PFObject]?, error) -> Void in
                        if error == nil  {
                            post.likesCount = usersArray!.count
                            for userObject in usersArray! {
                                if let likedUser = userObject as? PFUser {
                                    let user = User(objectId: likedUser.objectId!, name: likedUser.username!)
                                    post.likedUserArray.append(user)
                                }
                            }
                            post.currentUserLiked = post.isLikedByCurrentUser()
//                            tmpPosts.append(post)
                        }
//                        self.posts = tmpPosts
                        callback()
                    })
                }
                self.posts = tmpPosts
                callback()
            }
        }
    }
}


