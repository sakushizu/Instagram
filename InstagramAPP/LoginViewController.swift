//
//  LoginViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/11.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginNameText: UITextField!
    @IBOutlet weak var loginPasswordText: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let currentUser = CurrentUser.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPasswordText?.secureTextEntry = true
        loginButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        
        loginNameText.delegate = self
        loginPasswordText.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //ログイン機能
    @IBAction func loginButton(sender: UIButton) {
        if loginNameText.text!.isEmpty || loginPasswordText.text!.isEmpty {
            showAlert("User name or password is empty")
            return
        }
        let user = User(name: loginNameText.text!, password: loginPasswordText.text!, image: nil)
        user.login { (message) in
            if message == nil {
                print("login")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.showAlert(message)
            }
        }
    }
    
    @IBAction func tappedSignUpButton(sender: UIButton) {
        performSegueWithIdentifier("moveSignUpController", sender: self)
    }

    //アラート表示のメソッド
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //keyboardを閉じるdeligate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        loginNameText.resignFirstResponder()
        loginPasswordText.resignFirstResponder()
        return true
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        loginNameText.resignFirstResponder()
        loginPasswordText.resignFirstResponder()
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
