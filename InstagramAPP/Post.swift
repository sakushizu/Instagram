//
//  Post.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/06.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    var objectId: String!
    var text: String!
    var image: UIImage?
    var user: User?
    var createdAt: NSDate!
    var likedUserArray: [User] = []
    var likesCount:Int = 0
    var currentUserLiked = false
    
    
    init(objectId: String,text: String, image: UIImage?) {
        self.objectId = objectId
        self.text = text
        self.image = image
    }
    
    
    func save(callback: () -> Void) {
        let postsObject = PFObject(className: "Post")
        postsObject["text"] = text
        postsObject["image"] = image!.createFileForm()
        postsObject["userId"] = PFUser.currentUser()?.objectId
        postsObject["user"] = PFUser.currentUser()
        postsObject.saveInBackgroundWithBlock { (success, error) in
            if success {
                print("保存完了！")
                let post = Post(objectId: self.objectId, text: self.text, image: self.image!)
                PostManager.sharedInstance.posts.append(post)
                PostManager.sharedInstance.fetchPosts({ () -> Void in
                    print("fetchPostInSave")
                    callback()
                })
            }
        }
    }
    
    func isLikedByCurrentUser() -> Bool {
        let userIds = likedUserArray.map({(user: User) -> String in
            return user.objectId!
        })

        return userIds.indexOf(CurrentUser.sharedInstance.user.objectId!) != nil


    }
    
}
