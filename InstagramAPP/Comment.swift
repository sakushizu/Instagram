//
//  Comment.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/06.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

class Comment: NSObject {
    var user: User!
    var post: Post!
    var postId: String
    var text: String
    var date: NSDate!
    
    init(text: String, postId: String) {
        self.text = text
        self.postId = postId
    }
    
    func save(callback: () -> Void) {
        let commentObject = PFObject(className: "Comment")
        commentObject["text"] = text
        commentObject["postId"] = postId
        commentObject["user"] = PFUser.currentUser()
        
        commentObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                print("コメント保存完了")
                callback()
            }
        }
    }
    

}
