//
//  LoginViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/11.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectImageBtn: UIButton!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginNameText: UITextField!
    @IBOutlet weak var loginPasswordText: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        passwordText.secureTextEntry = true
        loginPasswordText.secureTextEntry = true
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //サインップ機能
    @IBAction func tapSelectImageBtn(sender: UIButton) {
        self.pickImageFromCamera()
        self.pickImageFromLibrary()
    }
    
    
    @IBAction func tapSignUpBtn(sender: UIButton) {
        let user = User(name: nameText.text!, password: passwordText.text!, image: profileImage.image)
        user.signUp { (message) in
            if let unwrappedMessage = message {
                self.showAlert(unwrappedMessage)
                print("サインアップ失敗")
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
                print("サインアップ成功")
            }
        }
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
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.showAlert(message)
            }
        }
    }
    
    
    //アラート表示のメソッド
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    //画像投稿機能
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.profileImage.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


