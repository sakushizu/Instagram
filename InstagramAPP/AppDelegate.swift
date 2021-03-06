//
//  AppDelegate.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/09/22.
//  Copyright (c) 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //initialize
        Comment.initialize()
        Post.initialize()
        
        // Initialize Parse.
        Parse.setApplicationId("ewnMhUt5LEJQacARWDIV52TUU6YN7HBr8syF6kF9",
            clientKey: "xh39eizcma2bADyVYefXoz6DBDtaoGQ1QI7kw1pj")

        
//        Get PFObject with objectId
//        let query = PFQuery(className: "Post")
//        query.getObjectInBackgroundWithId("W43iL2929w"){ (object, error) -> Void in
//            let type = object.dynamicType
//            print(type)
//        }
        
        if let PFCurrentUser = PFUser.currentUser() {
            CurrentUser.sharedInstance.user = User(objectId: PFCurrentUser.objectId!, name: PFCurrentUser.username!)
            let userImageFile = PFCurrentUser["image"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                if error == nil {
                    CurrentUser.sharedInstance.user.image = UIImage(data: imageData!)
                }
            })
   
        }
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
//        CurrentUser.sharedInstance.user = User(objectId: PFUser.currentUser()!.objectId!, name: PFUser.currentUser()!.username!)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

