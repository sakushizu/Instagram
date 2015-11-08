//
//  UserLIkedPostTavleView.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/11/02.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit

class UserLikedPostTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let userPostManager = CurrentUser.sharedInstance
    
    //ソースコードでインスタンスを生成した場合
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //プロトコル指定
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(UINib(nibName: "UserLikedPostTableViewCell", bundle: nil), forCellReuseIdentifier: "UserLikedPostTableViewCell")
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
        return userPostManager.userLikedPosts.count
    }
    
    //セル内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserLikedPostTableViewCell", forIndexPath: indexPath) as! UserLikedPostTableViewCell
        let post = userPostManager.userLikedPosts[indexPath.row]
        cell.postImageView.image = post.image
        cell.postTitle.text = post.text
        cell.data.text = conversionDateFormat(post.createdAt)
        cell.userName.text = post.user?.name
        cell.userImgeView.image = post.user?.image
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

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
