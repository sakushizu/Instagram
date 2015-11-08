//
//  SignUpViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/15.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectImageBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.secureTextEntry = true
        
        nameText.delegate = self
        passwordText.delegate = self
        
        loginBtn.layer.cornerRadius = 5
        signUpBtn.layer.cornerRadius = 5
        selectImageBtn.layer.cornerRadius = 5
        profileImage.layer.cornerRadius = self.profileImage.layer.bounds.width/2
        self.profileImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //buttonアクション
    //icon画像選択
    @IBAction func tapSelectImageBtn(sender: UIButton) {
        //アクションシートを生成
        let alertController = UIAlertController(title: "", message:
            "prease select", preferredStyle: UIAlertControllerStyle.ActionSheet)
        //アクションシートの表示
        self.presentViewController(alertController, animated: true, completion: nil)
        let cameraAction = UIAlertAction(title: "take a photo", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
            self.pickImageFromCamera()
        })
        let libraryAction = UIAlertAction(title: "choose from library", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
            self.pickImageFromLibrary()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        //アクションシートにアクションの追加
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
    }
    
    //サインアップ機能
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
    
    //login画面遷移
    @IBAction func tappedLoginButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("moveLoginController", sender: self)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameText.resignFirstResponder()
        passwordText.resignFirstResponder()
        return true
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        nameText.resignFirstResponder()
        passwordText.resignFirstResponder()
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



