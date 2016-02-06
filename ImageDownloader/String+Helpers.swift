//
//  String+Helpers.swift
//  ImageDownloader
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Foundation

extension String {
    
    func containsDigit() -> Bool {
        return rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet(), options: NSStringCompareOptions.NumericSearch, range: nil) == nil ? false : true
    }
    
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    
    var URL:NSURL? {
        get {
            return NSURL(string: self)
        }
    }
}