//
//  User.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/06.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    
    var name: String
    var password: String
    var image: UIImage?
    
    init(name: String, password: String, image: UIImage?) {
        self.name = name
        self.password = password
        self.image = image
    }
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    func signUp(callback: (message: String?) -> Void) {
        let user = PFUser()
        user.username = name
        user.password = password
        user["image"] = image!.createFileForm()
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            callback(message: error?.userInfo["error"] as? String)
            if let unwrappedError = error {
                print(unwrappedError.userInfo["error"] as? String)
                print("sign up失敗")
            } else {
                print("sign up成功")
            }
        }
        
        print("\(name),\(password)")
    }
    
    func login(callback: (message: String?) -> Void) {
        PFUser.logInWithUsernameInBackground(self.name, password: self.password) { (user, error) -> Void in
            if error == nil {
                callback(message: nil)
            } else {
                callback(message: error?.userInfo["error"] as? String)
            }
        }
    }


}
