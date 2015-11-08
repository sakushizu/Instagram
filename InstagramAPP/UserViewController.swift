//
//  UserViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/31.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIScrollViewDelegate,UIGestureRecognizerDelegate{

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var showUserPostButton: UIButton!
    @IBOutlet weak var showLikedPostButton: UIButton!
    
    let userPostManager = CurrentUser.sharedInstance
    //ボタンを管理するための配列を定義
    
    var userTableView: UserTableView!
    var userLikedPostTableView: UserLikedPostTableView!
    
    let pink = UIColor(red: 255 / 255, green: 214 / 255, blue: 204 / 255, alpha: 1.0)
    let hotPink = UIColor(red: 232 / 255, green: 142 / 255, blue: 146 / 255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        userIcon.layer.cornerRadius = userIcon.layer.bounds.width/2
        userIcon.clipsToBounds = true
//        userIcon.image = userPostManager.user.image
//        userName.text = userPostManager.user.name
        
        //sitesScrollView
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width*2, self.scrollView.frame.height)
        self.scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.directionalLockEnabled = true
        setTabButton(showUserPostButton)
        setTabButton(showLikedPostButton)
        
        setSelectedButton(showUserPostButton, selected: true)
        
//        // UILongPressGestureRecognizer宣言
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
//        // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
//        longPressRecognizer.delegate = self
//        // tableViewにrecognizerを設定
//        userTableView.addGestureRecognizer(longPressRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        userPostManager.fetchUserPosts { () -> Void in
            self.setTableView(0)
            self.userTableView.reloadData()
        }
        userPostManager.fetchUserLikedPosts {() -> Void in
            self.setTableView(self.view.frame.width)
            self.userLikedPostTableView.reloadData()
        }
        
        userIcon.image = userPostManager.user.image
        userName.text = userPostManager.user.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func tappedShowPostButton(sender: UIButton) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    @IBAction func tappedShowLikeButton(sender: UIButton) {
        scrollView.setContentOffset(CGPointMake(self.view.frame.width, 0), animated: true)
    }
    
    
    func setTableView(x: CGFloat){
        if x == 0 {
            let frame = CGRectMake(x, 0, self.view.frame.width, scrollView.frame.height)
            userTableView = UserTableView(frame: frame, style: UITableViewStyle.Plain)
            userTableView.estimatedRowHeight = 270
            userTableView.rowHeight = UITableViewAutomaticDimension
            self.scrollView.addSubview(userTableView)
        } else {
            let frame = CGRectMake(x, 0, self.view.frame.width, scrollView.frame.height)
            userLikedPostTableView = UserLikedPostTableView(frame: frame, style: UITableViewStyle.Plain)
            userLikedPostTableView.estimatedRowHeight = 280
            userLikedPostTableView.rowHeight = UITableViewAutomaticDimension
            self.scrollView.addSubview(userLikedPostTableView)
        }

    }
    
    func setTabButton(tabButton: UIButton){
        tabButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabButton.titleLabel?.font = UIFont(name: "HirakakuProN-W6", size: 13)
        tabButton.backgroundColor = pink
        tabButton.layer.cornerRadius = 5
        tabButton.layer.borderColor = UIColor.whiteColor().CGColor
        tabButton.layer.borderWidth = 1
        tabButton.setTitleColor(hotPink, forState: UIControlState.Selected)
        tabButton.layer.masksToBounds = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        chengeButtonColor()
    }
    
    //自動スクロールが終了時に呼ばれる
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        chengeButtonColor()
    }
    
    func setSelectedButton(button: UIButton, selected: Bool) {
        button.selected = selected
        button.layer.borderColor = button.titleLabel?.textColor.CGColor
    }
    
    func chengeButtonColor() {
        if scrollView.contentOffset.x == 0 {
            setSelectedButton(showUserPostButton, selected: true)
            setSelectedButton(showLikedPostButton, selected: false)
        } else {
            setSelectedButton(showUserPostButton, selected: false)
            setSelectedButton(showLikedPostButton, selected: true)
        }
    }
    
//    /* 長押しした際に呼ばれるメソッド */
//    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
//        print("aaaaaaaaaaaa")
//        // 押された位置でcellのPathを取得
//        let point = recognizer.locationInView(userTableView)
//        let indexPath = userTableView.indexPathForRowAtPoint(point)
//        if indexPath == nil {
//        } else if recognizer.state == UIGestureRecognizerState.Began  {
//            print("sssss")
//            // 長押しされた場合の処理
//            let selectPost = CurrentUser.sharedInstance.userPosts[indexPath!.row]
//            SweetAlert().showAlert("Are you sure?", subTitle: "You file will permanently delete!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
//                if isOtherButton == true {
//                    
//                    print("Cancel Button  Pressed")
//                }
//                else {
//                    SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.Success)
//                }
//            }
//        }
//    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
