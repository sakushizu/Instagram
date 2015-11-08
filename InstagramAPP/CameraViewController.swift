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
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    var postedImage: UIImage!
    var timelineVC: TimeLineTableViewController!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        libraryButton.layer.cornerRadius = 5
        cameraButton.layer.cornerRadius = 5
        
        let leftBackBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedBackBtn")
        self.navigationItem.setLeftBarButtonItems([leftBackBarButtonItem], animated: true)
        
        let rightBackBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedNextBtn")
        self.navigationItem.setRightBarButtonItems([rightBackBarButtonItem], animated: true)
        
        postImage.image = postedImage

        }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //写真機能を呼ぶ
    @IBAction func tappedCameraButtn(sender: UIButton) {
        self.pickImageFromCamera()
    }

    @IBAction func tappedLibraryButton(sender: UIButton) {
        self.pickImageFromLibrary()
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.postImage.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tappedBackBtn() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tappedNextBtn() {
        if self.postImage.image == nil {
            //アクションシート
            let alertController = UIAlertController(title: "", message:
                "Select picture", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("postView",sender: self)
        }
    }
    //画面遷移の時に画像を渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "postView") {
            let secondController: PostViewController = segue.destinationViewController as! PostViewController
            secondController.customDelegate = self.timelineVC
            if let postImage = self.postImage.image {
                secondController.postViewImage = postImage
            }
        }
    }
}

