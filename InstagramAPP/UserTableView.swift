//
//  UserTableView.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/11/01.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit

class UserTableView: UITableView, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate{
    
    let userPostManager = CurrentUser.sharedInstance
    
    //ソースコードでインスタンスを生成した場合
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //プロトコル指定
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(UINib(nibName: "UserPostTableViewCell", bundle: nil), forCellReuseIdentifier: "UserPostTableViewCell")
        
        // UILongPressGestureRecognizer宣言
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
        longPressRecognizer.delegate = self
        // tableViewにrecognizerを設定
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //セル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPostManager.userPosts.count
    }
    
    //セル内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserPostTableViewCell", forIndexPath: indexPath) as! UserPostTableViewCell
        let post = userPostManager.userPosts[indexPath.row]
        cell.postImageView.image = post.image
        cell.postText.text = post.text
        cell.data.text = conversionDateFormat(post.createdAt)
        return cell

    }

    //時刻表示の変更
    func conversionDateFormat(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        return dateFormatter.stringFromDate(date)
    }
    
    /* 長押しした際に呼ばれるメソッド */
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        // 押された位置でcellのPathを取得
        let point = recognizer.locationInView(self)
        let indexPath = self.indexPathForRowAtPoint(point)
        if indexPath == nil {
        } else if recognizer.state == UIGestureRecognizerState.Began  {
            // 長押しされた場合の処理
            let selectPost = CurrentUser.sharedInstance.userPosts[indexPath!.row]
            SweetAlert().showAlert("Are you sure?", subTitle: "You file will permanently delete!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    print("Cancel Button  Pressed")
                }
                else {
                    CurrentUser.sharedInstance.deletePost(selectPost, callback: { () -> Void in
                        self.reloadData()
                    })
                    SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.Success)
                }
            }
        }
    }
        

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
