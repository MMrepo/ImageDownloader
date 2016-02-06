//
//  SGImageCacheImageDownloader.swift
//  
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import SGImageCache

class SGImageCacheImageDownloader: ImageDownloadable {
    
    func haveImageWithURL(urlString: String) -> Bool {
        return SGImageCache.haveImageForURL(urlString)
    }
        
    func getImageWithURL(urlString: String) -> Promise<UIImage> {
        return Promise { fulfill, reject in
            SGImageCache.getImageForURL(urlString, thenDo: { (image) -> Void in
                fulfill(image)
            })
        }
    }
    
    func getSlowlyImageWithURL(urlString: String) -> Promise<UIImage>{
        return Promise { fulfill, reject in
            SGImageCache.slowGetImageForURL(urlString, thenDo: { (image) -> Void in
                print("slowly get image: \(image)")
                fulfill(image)
            })
        }
    }
    
    func changePriority(priority:DownloadTaskPriority, forImageWithURL urlString: String) {
        switch priority
        {
        case .Low:
            SGImageCache.moveTaskToSlowQueueForURL(urlString)
        default:
            break
        }
    }
    
    func cancelRetrievingImageWithURL(urlString: String) {
        if let task = SGImageCache.existingSlowQueueTaskFor(urlString) {
            print("cancel: \(urlString)")
            task.cancel()
        }
    }
    
    func clearCache() {
        SGImageCache.flushImagesOlderThan(0)
    }
}
