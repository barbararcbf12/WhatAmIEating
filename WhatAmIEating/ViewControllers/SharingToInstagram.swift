//
//  SharingToInstagram.swift
//  WhatAmIEating
//
//  Created by Bárbara Ferreira on 22/04/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import Foundation
import UIKit
import Photos

class SocialShare: NSObject {
    static let shared = SocialShare()
    
    func postImageToInstagram(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(SocialShare.image(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error != nil {
            print(error ?? "ERROR")
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let lastAsset = fetchResult.firstObject {
            let localIdentifier = lastAsset.localIdentifier
            let u = "instagram://library?LocalIdentifier=" + localIdentifier
            let openUrl = NSURL(string: u)
            UIApplication.shared.open(openUrl! as URL, options: [:], completionHandler: nil)
            //shared.openURL(NSURL(string: u)! as URL) //
        }
    }
}
