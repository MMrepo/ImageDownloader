//
//  SynchronizedDictionary.swift
//  
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Foundation

public class SynchronizedDictionary<Key:Hashable,Value> {
    private var dictionary: [Key:Value] = [:]
    private let accessQueue = dispatch_queue_create("SynchronizedDictionaryAccess", DISPATCH_QUEUE_CONCURRENT)
    
    public func updateValue(newValue: Value, forKey key: Key) {
        dispatch_barrier_async(self.accessQueue) {
            self.dictionary.updateValue(newValue, forKey: key)
        }
    }
    
    public func removeValueForKey(key: Key) {
        dispatch_barrier_async(self.accessQueue) {
            self.dictionary.removeValueForKey(key)
        }
    }
    
    public subscript(key: Key) -> Value? {
        set {
            dispatch_barrier_async(self.accessQueue) {
                self.dictionary[key] = newValue
            }
        }
        get {
            var element: Value? = nil
            
            dispatch_sync(self.accessQueue) {
                element = self.dictionary[key]
            }
            
            return element
        }
    }
    
    public var count:Int {
        get {
            var count: Int? = nil
            
            dispatch_sync(self.accessQueue) {
                count = self.dictionary.count
            }
            
            return count ?? 0
        }
    }
}
