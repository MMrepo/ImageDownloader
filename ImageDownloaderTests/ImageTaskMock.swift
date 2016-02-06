//
//  ImageTaskMock.swift
//
//
//  Created by Mateusz Małek on 29.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Foundation
@testable import ImageDownloader

class ImageTaskMock: ImageTask {
    init() {
        
    }
    
    //MARK: - ImageTask protocol
    func cancel() {
        
    }
    
    func urlString() -> String? {
        return self.url
    }
    
    var url:String?
}