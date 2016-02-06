//
//  ImageDownloadable.swift
//  
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit

enum DownloadTaskPriority:Float
{
    case Low = 0.25
    case Medium = 0.5
    case High = 0.75
    case VeryHigh = 0.9
}

enum ImageDownloaderErrorCode:ErrorType
{
    case WrongImageURL
    case InternalError(NSError)
    case TaskContainerError
    case TaskAlreadyRunning
}

protocol ImageDownloadable {
    
    func haveImageWithURL(urlString: String) -> Bool
    func getImageWithURL(urlString: String) -> Promise<UIImage>
    func getSlowlyImageWithURL(urlString: String) -> Promise<UIImage>
    func changePriority(priority:DownloadTaskPriority, forImageWithURL urlString: String)
    func clearCache()
    func cancelRetrievingImageWithURL(urlString: String) 
}