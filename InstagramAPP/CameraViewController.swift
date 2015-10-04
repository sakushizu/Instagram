//
//  CameraViewController.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/09/26.
//  Copyright (c) 2015年 櫻本静香. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pickImageFromCamera()
        self.pickImageFromLibrary()
        
        var leftBackBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedBackBtn")
        self.navigationItem.setLeftBarButtonItems([leftBackBarButtonItem], animated: true)
        
        var rightBackBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedNextBtn")
        self.navigationItem.setRightBarButtonItems([rightBackBarButtonItem], animated: true)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            println(image)
            self.postImage.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tappedBackBtn() {
        self.pickImageFromCamera()
        self.pickImageFromLibrary()
        
    }
    
    func tappedNextBtn() {
        performSegueWithIdentifier("postView",sender: self)
        
    }
        
        

    
    
  
}