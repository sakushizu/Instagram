//
//  TimeLineTableTableViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/09/30.
//  Copyright (c) 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse
import Social


class TimeLineTableViewController: UITableViewController, PostTableViewCellDelegate, PostViewControllerDelegate,UIGestureRecognizerDelegate {
    
    
    let postManager = PostManager.sharedInstance
    var selectedPost: Post!
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UILongPressGestureRecognizer宣言
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
        longPressRecognizer.delegate = self
        // tableViewにrecognizerを設定
        tableView.addGestureRecognizer(longPressRecognizer)
        
        if PFUser.currentUser() == nil {
            performSegueWithIdentifier("loginViewController", sender: self)
        } else {
            postManager.fetchPosts { () -> Void in
                self.tableView.reloadData()
            }
        }
        
        //スクロールしたら更新処理
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("RefreshArticles"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        let pink = UIColor(red: 255 / 255, green: 214 / 255, blue: 204 / 255, alpha: 1.0)
        let hotPink = UIColor(red: 232 / 255, green: 142 / 255, blue: 146 / 255, alpha: 1.0)
        
        self.tableView.registerNib(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        //セルの高さを自動で計算
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationController?.navigationBar.tintColor = hotPink
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:hotPink]
        navigationController?.navigationBar.barTintColor = pink
        
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "callCamerafunction:")
        let logoutButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Reply, target: self, action: "logout:")
        self.navigationItem.setRightBarButtonItem(cameraButton, animated: true)
        self.navigationItem.setLeftBarButtonItem(logoutButton, animated: true)
        
//        let postViewController = PostViewController()
//        postViewController.customDelegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return postManager.posts.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        // 長押し
//        let myLongPressGesture = UILongPressGestureRecognizer(target: self, action: "lognPress:")
//        myLongPressGesture.minimumPressDuration = 2.0
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as! PostTableViewCell
        let post = postManager.posts[indexPath.row]
        cell.post = post
        cell.postImage.image = post.image
        cell.postTitle.text = post.text
        cell.postTitle.numberOfLines = 0
        cell.userImage.image = post.user?.image
        cell.userName.text = post.user?.name
        cell.postData.text = conversionDateFormat(post.createdAt)
        cell.changeLikeImage(post.currentUserLiked)
        cell.likesNumLabel.text = "\(post.likesCount)likes"
        cell.customDelegate = self
        return cell
    }

    
    //delegate
    func didFinishedFetchPosts() {
        tableView.reloadData()
    }
    
    
    func callCamerafunction(sender: UIButton) {
        self.performSegueWithIdentifier("moveCameraViewController", sender: self)
    }
    
    func logout(sender: UIButton) {
        PFUser.logOut()
        performSegueWithIdentifier("loginViewController", sender: self)
    }
    
    //更新処理
    func RefreshArticles() {
        postManager.fetchPosts { () -> Void in
            self.tableView.reloadData()
        }
        self.refreshControl?.endRefreshing()
    }
    
    //delegate
    func tappedCommentButton(post: Post) {
        selectedPost = post
        self.performSegueWithIdentifier("showCommentViewController", sender: self)
    }
    
    func tappedShareButton(post: Post) {
        let alertController = UIAlertController(title: "", message: "Select share App", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: {
            (action: UIAlertAction!) -> Void in
            self.facebookShare(post)
        })
        let twitterAction = UIAlertAction(title: "Twitter", style: .Default, handler: {
            (action: UIAlertAction!) -> Void in
            self.twitterShare(post)
        })
        alertController.addAction(facebookAction)
        alertController.addAction(twitterAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func facebookShare(post: Post) {
        let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookVC.setInitialText("\(post.text) #Instagram")
        facebookVC.addImage(post.image)
        self.presentViewController(facebookVC, animated: true, completion: nil)
    }
    
    func twitterShare(post: Post) {
        let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterVC.setInitialText("\(post.text) #Instagram")
        twitterVC.addImage(post.image)
        self.presentViewController(twitterVC, animated: true, completion: nil)
    }

    
    
    //画面遷移時に値を渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCommentViewController") {
            let secondController:CommentViewController = segue.destinationViewController as! CommentViewController
            secondController.post = selectedPost
        } else if (segue.identifier == "moveCameraViewController") {
            print("moveCameraSegue")
            let secondController = segue.destinationViewController as! CameraViewController
            secondController.timelineVC = self
        }
    }
    
    //時刻表示の変更
    func conversionDateFormat(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        return dateFormatter.stringFromDate(date)
    }
    
    func lognPress(sender: UILongPressGestureRecognizer) {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("lognPress")
    }
    
    
    /* 長押しした際に呼ばれるメソッド */
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        // 押された位置でcellのPathを取得
        let point = recognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if indexPath == nil {
        } else if recognizer.state == UIGestureRecognizerState.Began  {
            // 長押しされた場合の処理
            let selectPost = postManager.posts[indexPath!.row]
            UIImageWriteToSavedPhotosAlbum(selectPost.image!, nil, nil, nil)
            SweetAlert().showAlert("Saved", subTitle: "", style: AlertStyle.Success)
        }
    }
    
//    func alert() {
//        let alert: UIAlertController = UIAlertController(title: "", message: "saved!!", preferredStyle: .Alert)
//        self.presentViewController(alert, animated: true) { () -> Void in
//            let delay = 0.5 * Double(NSEC_PER_SEC)
//            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue(), {
//                self.dismissViewControllerAnimated(true, completion: nil)
//            })
//        }
//    }

}



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */


