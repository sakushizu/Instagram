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
    var text: String!
    var image: UIImage?
    var user: User?
    
    init(text: String, image: UIImage?) {
        self.text = text
        self.image = image
    }
    
    
    func save() {
        let postsObject = PFObject(className: "Post")
        postsObject["text"] = text
        postsObject["image"] = image!.createFileForm()
        let relation = postsObject.relationForKey("user")
        relation.addObject(PFUser.currentUser()!)
        postsObject.saveInBackgroundWithBlock { (success, error) in
            if success {
                print("保存完了！")
            }
        }
    }
    
    

    
    
    
}
