//
//  CustomTabBarrController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/09/27.
//  Copyright (c) 2015年 櫻本静香. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pink = UIColor(red: 255 / 255, green: 214 / 255, blue: 204 / 255, alpha: 1.0)
        let hotPink = UIColor(red: 232 / 255, green: 142 / 255, blue: 146 / 255, alpha: 1.0)
        //Tab Barの背景色を設定
        UITabBar.appearance().barTintColor = pink
        UITabBar.appearance().tintColor = hotPink
        //tabberItemの画像
        let userImage = UIImage(named: "User Filled-32.png")
        let homeImage = UIImage(named: "home.png")
        //tabberCOntrollerと紐付いてるviewControllerの取得
        let firstViewController = self.viewControllers![0] 
        let secondViewController = self.viewControllers![1] 
        //それぞれに画像を設定
        firstViewController.tabBarItem = UITabBarItem(title: "home", image: homeImage, selectedImage: homeImage)
        secondViewController.tabBarItem = UITabBarItem(title: "my page", image: userImage, selectedImage: userImage)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
