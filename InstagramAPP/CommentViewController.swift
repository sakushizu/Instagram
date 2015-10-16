//
//  CommentViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/15.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userImage: UIImage!
    var postText: String!
    var userName: String!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!

    @IBOutlet weak var commentSendBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.dataSource = self
        commentTableView.delegate = self
        
        commentSendBtn.layer.cornerRadius = 5
        
        //セルの高さを自動で計算
        commentTableView.estimatedRowHeight = 78
        commentTableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //Table Viewのセルの数を指定
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
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
            imageView.image = userImage
            nameLabel.text = userName
            commentLabel.text = postText
            
            
        } else {
            
            imageView.image = UIImage(named: "pinkritoru .jpg")
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.layer.cornerRadius = imageView.layer.bounds.width/2
            imageView.clipsToBounds = true
            nameLabel.text = "sakura"
            dataLabel.text = "54m"
            commentLabel.text = "お腹すいたなああああああああああああああああああ"
            commentLabel.numberOfLines = 0
        }
        return cell
    }
    
    @IBAction func tapCommentSendBtn(sender: UIButton) {
        
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
