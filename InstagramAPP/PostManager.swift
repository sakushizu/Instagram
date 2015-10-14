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
    
    func fetchPosts() {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.posts = []
                let posts = objects as? [PFObject]!
                for post in posts! {
                    let text      = post["text"] as! String
                    let imageFile = post["image"] as! PFFile
                    let post = Post(text: text, image: nil)
                    self.posts.append(post)
//                    self.posts.insert(post, atIndex: 0)
                    imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if error == nil {
                            post.image = UIImage(data: imageData!)
                            self.delegate?.didFinishedFetchPosts()
                        }
                    })
                }
            }
        }
    }
    
}


