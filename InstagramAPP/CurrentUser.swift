//
//  CurrentUser.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/25.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

@objc protocol CurrentUserDelegate {
    func didFinishedFetchUserPosts()
}

class CurrentUser: NSObject {
    static let sharedInstance = CurrentUser()
    var user: User!
    var userPosts: [Post] = []
    var userLikedPosts: [Post] = []
    
   weak var delegate: CurrentUserDelegate?

    func fetchUserPosts(callback: () -> Void) {
        let postsQuery = PFQuery(className: "Post")
        postsQuery.whereKey("userId", equalTo: user.objectId!)
        postsQuery.orderByDescending("createdAt")
        postsQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.userPosts = []
                if objects!.count > 0 {
                    for object in (objects! as [PFObject]) {
                        let objectId = object.objectId!
                        let text = object["text"] as! String
                        let postImageFile = object["image"] as! PFFile
                        let post = Post(objectId: objectId, text: text, image: nil)
                        postImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                            if error == nil {
                                post.image = UIImage(data: imageData!)
//                               self.delegate?.didFinishedFetchUserPosts()
                                
                                post.createdAt = object.createdAt
                                self.userPosts.append(post)
                               callback()
                            }
                        })
                        
                    }
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    func fetchUserLikedPosts(callback: () -> Void) {
        let likeQuery = PFQuery(className: "Like")
        likeQuery.whereKey("userId", equalTo: user.objectId!)
        likeQuery.orderByDescending("createdAt")
        likeQuery.includeKey("likedPost")
        likeQuery.includeKey("likedPost.user")
        likeQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.userLikedPosts = []
                if objects!.count > 0 {
                    for object in (objects! as [PFObject]) {
                        if object["likedPost"] != nil {
                            let postObject = object["likedPost"] as! PFObject
                            let objectId = postObject.objectId!
                            let text = postObject["text"] as! String
                            let postImageFile = postObject["image"] as! PFFile
                            let post = Post(objectId: objectId, text: text, image: nil)
                            post.createdAt = postObject.createdAt
                            postImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                if error == nil {
                                    post.image = UIImage(data: imageData!)
                                }
                            })
                            let userObject = postObject["user"] as! PFUser
                            let userName = userObject.username!
                            let imageFile = userObject["image"] as! PFFile
                            let user = User(name: userName)
                            imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                if error == nil {
                                    user.image = UIImage(data: imageData!)
                                    callback()
                                }
                            })
                            post.user = user
                            self.userLikedPosts.append(post)
//                            callback()
                        }
                    }
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    //投稿の削除
    func deletePost(post: Post, callback: () -> Void) {
        let postQuery = PFQuery(className: "Post")
        postQuery.whereKey("objectId", equalTo: post.objectId!)
        postQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if error == nil {
                object?.deleteInBackgroundWithBlock({ (sucsess, error) -> Void in
                    if sucsess {
                        callback()
                        print("削除しました")
                    }
                })
                
               
            }
        }
    }
    
}
