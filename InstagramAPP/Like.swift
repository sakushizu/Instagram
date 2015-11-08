//
//  Like.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/25.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

class Like: NSObject {
    var user: PFUser
    var post: Post
    var postManager = PostManager.sharedInstance
    
    init(user: PFUser, post: Post) {
        self.user = user
        self.post = post
    }
    
    func save(callback: () -> Void) {
        //postのlikedUsersに自分がいなかったら保存
        //対象のpostを取得
        let postQuery = PFQuery(className: "Post")
        postQuery.whereKey("objectId", equalTo: post.objectId)
        postQuery.getFirstObjectInBackgroundWithBlock { (postObject, error) -> Void in
            if error == nil {
                //likedUserの中から自分を探す
                let likedUserRelation = postObject!.relationForKey("likedUser")
                let likedUser =  likedUserRelation.query()?.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
                likedUser!.getFirstObjectInBackgroundWithBlock({ (userObject, notFind) -> Void in
                    //すでにいいね済みだった場合は削除
                    if notFind == nil  {
                        likedUserRelation.removeObject(userObject!)
                        self.post.currentUserLiked = false
                        self.post.likesCount -= 1
                        print("削除しました")
                    //まだいいねしてなかったら追加
                    } else {
                        self.post.currentUserLiked = true
                        self.post.likesCount += 1
                        print("追加しました")
                        likedUserRelation.addObject(PFUser.currentUser()!)
                    }
                    postObject!.saveInBackgroundWithBlock { (success, error) -> Void in
                        if success {
                            print("処理完了")
                            callback()
                        }
                    }
                })
            } else {
                print("\(error?.localizedDescription)")
            }
            
            let likeQuery = PFQuery(className: "Like")
            likeQuery.whereKey("postId", equalTo: self.post.objectId)
            likeQuery.whereKey("userId", equalTo: self.user.objectId!)
            likeQuery.getFirstObjectInBackgroundWithBlock { (likeObject, notFind) -> Void in
                if notFind == nil {
                    likeObject?.deleteInBackground()
                } else {
                    let likeObject = PFObject(className: "Like")
                    likeObject["postId"] = self.post.objectId
                    likeObject["userId"] = self.user.objectId
                    likeObject["likedPost"] = postObject
                    likeObject.saveInBackgroundWithBlock { (success, error) -> Void in
                        if success {
                            print("like保存完了")
                        }
                    }
                }
            }
        }
    }
}


