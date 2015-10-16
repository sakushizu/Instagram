//
//  TimeLineTableTableViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/09/30.
//  Copyright (c) 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

class TimeLineTableViewController: UITableViewController, PostManagerDelegate, PostTableViewCellDelegate {
    
    let postManager = PostManager.sharedInstance
    var postCell: PostTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pink = UIColor(red: 255 / 255, green: 214 / 255, blue: 204 / 255, alpha: 1.0)
        
        
         self.tableView.registerNib(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = pink
        title = "Instagram"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
        postManager.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        postManager.fetchPosts { () -> Void in
            self.tableView.reloadData()
        }
        
        super.viewWillAppear(animated)
        if PFUser.currentUser() == nil {
            performSegueWithIdentifier("loginViewController", sender: self)
        }
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as! PostTableViewCell
        let post = postManager.posts[indexPath.row]
        print(indexPath.row)
        cell.postImage.image = post.image
        cell.postTitle.text = post.text
        cell.userImage.image = post.user?.image
        cell.userName.text = post.user?.name
        cell.customDelegate = self
        postCell = cell
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350
    }
    
    //delegate
    func didFinishedFetchPosts() {
        tableView.reloadData()
    }
    
    func logout() {
        PFUser.logOut()
        performSegueWithIdentifier("loginViewController", sender: self)
    }
    
    func tappedCommentButton() {
        self.performSegueWithIdentifier("showCommentViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCommentViewController" {
            let secondController:CommentViewController = segue.destinationViewController as! CommentViewController
            if let image = postCell.userImage.image {
                secondController.userImage = image
            }
            if let text = postCell.postTitle.text {
                secondController.postText = text
            }
            if let name = postCell.userName.text {
                secondController.userName = name
            }
            
        }
    }

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


