//
//  RetrieveImageTask+KingfisherImageDownloader.swift
//  
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Kingfisher

extension RetrieveImageTask: ImageTask
{
    func cancel() {
        self.downloadTask?.cancel()
    }
    
    func urlString() -> String? {
        return self.downloadTask?.URL?.absoluteString
    }
    
    func suspend() {
        self.downloadTask?.suspend()
    }
    
    var state:NSURLSessionTaskState {
        get {
            return (self.downloadTask?.state)!
        }
    }
    
    var priority:Float {
        get {
            return self.downloadTask?.priority ?? 0
        }
        set {
            self.downloadTask?.priority = newValue
        }
    }
}