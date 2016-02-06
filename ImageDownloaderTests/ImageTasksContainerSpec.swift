//
//  RetrieveImageTasksContainerSpec.swift
//  
//
//  Created by Mateusz Małek on 29.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//
import Foundation
import Quick
import Nimble
import Kingfisher
import XCTest

@testable import ImageDownloader

class ImageTasksContainerSpec: QuickSpec {

    override func spec() {
        var imageTasksContainer: ImageTasksContainer!
        let testURLString:String = "http://www.example.com/image"

        //MARK: - helpers method
        func createTaskAndAddToContainer() -> ImageTaskMock {
            let createdTask = ImageTaskMock()
            createdTask.url = testURLString
            imageTasksContainer.addTaskToStoredTasks(createdTask, withUrl: testURLString)
            return createdTask
        }
        
        beforeSuite { () -> () in
        }
        
        beforeEach { () -> () in
           imageTasksContainer = ImageTasksContainer()
        }
        
        afterEach { () -> () in
        }
        
        describe("Image tasks container") { () -> Void in
            
            it("Sould be empty after initialization") {
                expect(imageTasksContainer.count).to(equal(0))
            }
            
            context("after adding one task after initialization", { () -> Void in
                it("should contain only one task", closure: { () -> () in
                    createTaskAndAddToContainer()
                    expect(imageTasksContainer.count).to(equal(1))
                })
                
                it ("should contain task with given url", closure: { () -> () in
                    createTaskAndAddToContainer()
                    let containsTaskValue = imageTasksContainer.containsTaskWithURL(testURLString)
                    expect(containsTaskValue).to(beTrue())
                })
                
                it ("should return task with given url", closure: { () -> () in
                    let createdTask = createTaskAndAddToContainer()
                    let returnedTask = imageTasksContainer.getTaskWithURL(testURLString)
                    expect(returnedTask).toNot(beNil())
                    expect(returnedTask!.urlString()).to(equal(createdTask.urlString()))
                })
            })
            
            context("remove task", { () -> Void in
                it("should throw error if trying remove task from empty container", closure: { () -> () in
                    expect{ try imageTasksContainer.removeTaskFromStoredTasksWithURL(testURLString)
                        }.to(throwError(errorType: ImageTasksContainerError.self))
                })
                
                it("should decrease count of container", closure: { () -> () in
                    createTaskAndAddToContainer()
                    let containerCountAfterAdd = imageTasksContainer.count
                    try! imageTasksContainer.removeTaskFromStoredTasksWithURL(testURLString)
                    expect(imageTasksContainer.count).to(equal(containerCountAfterAdd-1))
                })
            })
        }
    }
}