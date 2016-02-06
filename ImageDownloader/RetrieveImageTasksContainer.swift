//
//  RetrieveImageTasksContainer.swift
//  
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import Foundation
import Kingfisher

protocol ImageTask {
    func cancel()
    func urlString() -> String?
    func suspend()
    var state:NSURLSessionTaskState { get }
    var priority:Float { get set }
}

enum ImageTasksContainerError: ErrorType {
    case EmptyList
}

class ImageTasksContainer {
    
    private let currentTasksContainer:SynchronizedDictionary<String,ImageTask>
    
    init(container: SynchronizedDictionary<String,ImageTask> = SynchronizedDictionary<String,ImageTask>()) {
        self.currentTasksContainer = container
    }
    
    func addTaskToStoredTasks(task:ImageTask, withUrl urlString:String) {
        self.currentTasksContainer[urlString] = task
    }
    
    func removeTaskFromStoredTasksWithURL(urlString:String) throws {
        guard self.currentTasksContainer.count != 0 else {
            throw ImageTasksContainerError.EmptyList
        }
        
        self.currentTasksContainer.removeValueForKey(urlString)
    }
    
    func containsTaskWithURL(urlString:String) -> Bool {
        let isCreated = getTaskWithURL(urlString) != nil
        return isCreated
    }
    
    func getTaskWithURL(urlString:String) -> ImageTask? {
        let task = currentTasksContainer[urlString]
        return task
    }
    
    var count:Int {
        get {
            return currentTasksContainer.count
        }
    }
}
