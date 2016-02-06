//
//  ImageManager.swift
//  
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import UIKit
import PromiseKit


class ImageManager {
    
    static let sharedInstance = ImageManager()
    
//    private var imageDownloader:ImageDownloadable = SGImageCacheImageDownloader()
    private var imageDownloader:ImageDownloadable = KingfisherImageDownloader()
    
    //MARK: public API
    func haveImageWithURL(urlString: String) -> Bool {
        return imageDownloader.haveImageWithURL(urlString)
    }
    
    func getImageWithURL(urlString: String) -> Promise<UIImage> {
        return imageDownloader.getImageWithURL(urlString)
    }
    
    func getSlowlyImageWithURL(urlString: String) -> Promise<UIImage> {
        return imageDownloader.getSlowlyImageWithURL(urlString)
    }
    
    func changePriority(priority:DownloadTaskPriority, forImageWithURL urlString: String) {
       self.imageDownloader.changePriority(priority, forImageWithURL: urlString)
    }
    
    func clearCache() -> Void {
        self.imageDownloader.clearCache()
    }
    
    func cancelRetrievingImageWithURL(urlString: String) {
        self.imageDownloader.cancelRetrievingImageWithURL(urlString)
    }
    
    //MARK: - initialization
    private init()
    {
    
    }
}
