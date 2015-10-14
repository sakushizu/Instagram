//
//  NSDate+Extension.swift
//  InstagramAPP
//
//  Created by 櫻本静香 on 2015/10/07.
//  Copyright © 2015年 櫻本静香. All rights reserved.
//

import Foundation
import UIKit
import Parse

extension UIImage {
    
//    func convertToPFFile() -> PFFile {
//        let imageData = UIImagePNGRepresentation(self)
//        let imageFile = PFFile(name: "imageFile.png", data: imageData!)
//        return imageFile
//    }
    
    
    struct ImageSize {
        static let height: CGFloat = 480
    }
    
    //UIImageをPFFileに変換
    func createFileForm() -> PFFile! {
        let ratio = self.size.width / self.size.height
        let resizedImage = resizeImage(self, towidth: ImageSize.height * ratio, andHeight: ImageSize.height)
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)!
        return PFFile(name: "image.jpg", data: imageData)
    }
    
    //画像のデータサイズを変更
    func resizeImage(originalImage: UIImage, towidth width: CGFloat, andHeight height: CGFloat) -> UIImage {
        let newSize = CGSizeMake(width, height)
        let newRectangle = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(newSize)
        originalImage.drawInRect(newRectangle)
        
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
