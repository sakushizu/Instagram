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
        //指定する色を定義
        let pink = UIColor(red: 255 / 255, green: 214 / 255, blue: 204 / 255, alpha: 1.0)
        //Tab Barの背景色を設定
        UITabBar.appearance().barTintColor = pink
        //tabberItemの画像
        let cameraImage = UIImage(named: "camera1")
        let homeImage = UIImage(named: "home")
        //tabberCOntrollerと紐付いてるviewControllerの取得
        let firstViewController = self.viewControllers![0] 
        let secondViewController = self.viewControllers![1] 
        //それぞれに画像を設定
        firstViewController.tabBarItem = UITabBarItem(title: "home", image: homeImage, selectedImage: homeImage)
        secondViewController.tabBarItem = UITabBarItem(title: "camera", image: cameraImage, selectedImage: cameraImage)

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
