//
//  KingfisherImageDownloader.swift
//  
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import PromiseKit

class KingfisherImageDownloader: ImageDownloadable {
    
    // Properties
    private let tasksContainer = ImageTasksContainer()
    
    //MARK: - initializers
    init() {
        prepareSession()
    }
    
    //MARK: - public API
    
    func haveImageWithURL(urlString: String) -> Bool {
        let cacheCheckResult = KingfisherManager.sharedManager.cache.isImageCachedForKey(urlString)
        return cacheCheckResult.cached
    }
    
    func getImageWithURL(urlString: String) -> Promise<UIImage> {
        return retrieveImageWithURL(urlString, priority: DownloadTaskPriority.VeryHigh)
    }
    
    func getSlowlyImageWithURL(urlString: String) -> Promise<UIImage> {
        return retrieveImageWithURL(urlString, priority: DownloadTaskPriority.Low)
    }
    
    func changePriority(priority:DownloadTaskPriority, forImageWithURL urlString: String) {
        if var task = tasksContainer.getTaskWithURL(urlString) {
            task.priority = priority.rawValue
        }
    }
    
    func clearCache() {
        KingfisherManager.sharedManager.cache.clearMemoryCache()
        KingfisherManager.sharedManager.cache.clearDiskCache()
    }

    func cancelRetrievingImageWithURL(urlString: String) {
        if let task = tasksContainer.getTaskWithURL(urlString) {
            task.suspend()
        }
    }
    
    //MARK: - private methods
    private func retrieveImageWithURL(urlString: String, priority:DownloadTaskPriority) -> Promise<UIImage> {
        return Promise { fulfill, reject in
            guard let url = urlString.URL else {
                reject(ImageDownloaderErrorCode.WrongImageURL)
                return
            }
            
            let optionInfo = getDefaultOptionForRetrieveImageWithPriority(priority)
            let completionHandler: CompletionHandler = { (image, error, cacheType, imageURL) -> () in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        do {
                            if let image = image {
                                fulfill(image)
                            } else if let error = error {
                                reject(ImageDownloaderErrorCode.InternalError(error))
                            }
                            try self.tasksContainer.removeTaskFromStoredTasksWithURL(urlString)
                        } catch {
                            reject(ImageDownloaderErrorCode.TaskContainerError)
                        }
                    }
            }
                
            if let oldTask = tasksContainer.getTaskWithURL(urlString) as? RetrieveImageTask {
                
                changePriority(priority, forImageWithURL: urlString)
                KingfisherManager.sharedManager.retrieveImageWithTask(oldTask, forURL: url, optionsInfo: optionInfo, progressBlock: nil, completionHandler: completionHandler)
                return
            }
            
            let task = KingfisherManager.sharedManager.retrieveImageWithURL(url, optionsInfo: optionInfo, progressBlock: nil, completionHandler: completionHandler)
            
            
            if !tasksContainer.containsTaskWithURL(urlString)
            {
                tasksContainer.addTaskToStoredTasks(task, withUrl: urlString)
            }
        }
    }
    
    private func getDefaultOptionForRetrieveImageWithPriority(priority: DownloadTaskPriority) -> KingfisherOptionsInfo {
        let optionInfo: KingfisherOptionsInfo = [
            .DownloadPriority(priority.rawValue)
        ]
        return optionInfo
    }
    
    private func prepareSession() {
        let sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 4
        KingfisherManager.sharedManager.downloader.sessionConfiguration = sessionConfiguration
    }
}
