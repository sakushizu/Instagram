//
//  PostViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/02.
//  Copyright (c) 2015年 櫻本静香. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postView: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postText.layer.cornerRadius = 5
        postText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        postText.layer.borderWidth = 1
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        self.view.addGestureRecognizer(tapGesture)
        
        shareBtn.layer.cornerRadius = 5
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func shareBtn(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        postText.resignFirstResponder()
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
