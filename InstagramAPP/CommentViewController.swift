
//
//  CommentViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/15.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CommentManagerDelegate, UITextFieldDelegate {

    var post: Post!
    var commentText: String!
    var commentedPost: CommentManager!
    
    let commentManager = CommentManager.sharedInstance
    
    @IBOutlet weak var textFieldScrollView: UIScrollView!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!

    @IBOutlet weak var commentSendBtn: UIButton!
    
    var txtActiveField: UITextField! //編集後のtextFieldを新しく格納する変数を定義
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentManager.delegate = self
        commentTextField.delegate = self
        
        let tapRecgnizer = UITapGestureRecognizer(target: self, action: "tapGesture:")
        self.view.addGestureRecognizer(tapRecgnizer)
        
        self.tabBarController!.tabBar.hidden = true
        
        commentSendBtn.layer.cornerRadius = 5

        //セルの高さを自動で計算
        commentTableView.estimatedRowHeight = 90
        commentTableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        commentManager.fetchComments(post) { () -> Void in
            self.commentTableView.reloadData()
        }
        
        // NSNotificationCenterへの登録処理
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //Table Viewのセルの数を指定
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return commentManager.comments.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = imageView.layer.bounds.width/2
        imageView.clipsToBounds = true
        let nameLabel = cell.viewWithTag(2) as! UILabel
        let dataLabel = cell.viewWithTag(3) as! UILabel
        let commentLabel = cell.viewWithTag(4) as! UILabel
        
        
        if indexPath.section == 0 {
            imageView.image = post.user?.image
            nameLabel.text = post.user?.name
            commentLabel.text = post.text
            dataLabel.text = conversionDateFormat(post.createdAt)
            
            
        } else {
            let comment = commentManager.comments[indexPath.row]
    
            imageView.image = comment.user.image
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.layer.cornerRadius = imageView.layer.bounds.width/2
            imageView.clipsToBounds = true
            nameLabel.text = comment.user.name
            dataLabel.text = conversionDateFormat(comment.date)
            commentLabel.text = comment.text
            commentLabel.numberOfLines = 0
        }
        return cell
        
    }
    
    @IBAction func tapCommentSendBtn(sender: UIButton) {
        let comment = Comment(text: commentTextField.text!, postId: post.objectId!)
        comment.save { () in
            self.commentTextField.text = ""
            self.commentManager.fetchComments(self.post) { () -> Void in
                self.commentTableView.reloadData()
            }
        }
    }
    
    //delegate
    func didFinishedFetchComments() {
        commentTableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        commentTextField.resignFirstResponder()
    }
    
    // Viewが非表示になるたびに呼び出されるメソッド
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // NSNotificationCenterの解除処理
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    //textFieldを編集する際に行われる処理
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        txtActiveField = textField //　編集しているtextFieldを新しいtextField型の変数に代入する
        return true
    }
    
    //キーボードが表示された時
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        //郵便入れみたいなもの
        let userInfo = notification.userInfo!
        //キーボードの大きさを取得
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        // 画面のサイズを取得
        let duration: NSTimeInterval = ((userInfo[UIKeyboardAnimationDurationUserInfoKey])?.doubleValue)!
        UIView.animateWithDuration(duration) { () -> Void in
            let transform: CGAffineTransform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height)
            self.view.transform = transform
        }
    }
    
    //ずらした分を戻す処理
    func handleKeyboardWillHideNotification(notification: NSNotification) {
//        textFieldScrollView.contentOffset.y = 0
        let userInfo = notification.userInfo!
        
        let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration: NSTimeInterval = ((userInfo[UIKeyboardAnimationDurationUserInfoKey])?.doubleValue)!
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.transform = CGAffineTransformIdentity
        }
    }
    
    
    func conversionDateFormat(date: NSDate) -> String {
        let outputFormatter = NSDateFormatter()
        outputFormatter.dateFormat = "MM/dd HH:mm"
        let outputDateString = outputFormatter.stringFromDate(date)
        return outputDateString
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
