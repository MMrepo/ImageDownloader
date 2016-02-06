//
//  KingfisherImageDownloaderSpec.swift
//
//
//  Created by Mateusz Małek on 26.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Foundation
import Quick
import Nimble
import OHHTTPStubs
import Kingfisher
import XCTest
import OHHTTPStubs

@testable import ImageDownloader

class KingfisherImageDownloaderSpec: QuickSpec {
    
    func addDefaultImageStub() {
        stub(isExtension("png") || isExtension("jpg") || isExtension("gif")) { _ in
            let stubPath = OHPathForFile("example.jpg", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type":"image/jpeg"])
        }
    }
    
    override func spec() {
        var imageDowloader:KingfisherImageDownloader!
        let testURLString = "https://example.com/example.jpg"
        
        beforeSuite { () -> () in
        
        }
        
        afterSuite { () -> () in
        }
        
        beforeEach { () -> () in
            imageDowloader = KingfisherImageDownloader()
            self.addDefaultImageStub()
        }
        
        afterEach { () -> () in
            OHHTTPStubs.removeAllStubs()
            imageDowloader.clearCache()
        }
        
        describe("ImageDownloader") { () -> Void in
            it("Sould download image with given url") {
                waitUntil(timeout: 1, action: { done in
                    imageDowloader.getImageWithURL(testURLString).then({ (image) in
                        done()
                    }).error({ error in
                        fail("Error: \(error)")
                        done()
                    })
                })
            }
            
            it("Should have cached image after downloading") {
                waitUntil(timeout: 1, action: { done in
                    imageDowloader.getImageWithURL(testURLString).then({ (image) in
                        let imageCached = imageDowloader.haveImageWithURL(testURLString)
                        expect(imageCached).to(beTrue())
                        done()
                    }).error({ error in
                        fail("Error: \(error)")
                        done()
                    })
                })
            }
        }
    }
}
