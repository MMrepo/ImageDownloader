//
//  ImagesTableViewController.swift
//
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import UIKit

class ImagesTableViewController: UITableViewController {
    
    let imagesCount = 100
    var imagesUrls:[NSURL] = []
    var heighestDisplayedIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 1...imagesCount {
            let red = Int(arc4random_uniform(255))
            let green = Int(arc4random_uniform(255))
            let blue = Int(arc4random_uniform(255))
            let color = String(format: "%x%x%x", red, green, blue)
            imagesUrls.append(NSURL(string: "http://dummyimage.com/1024x480/000000/\(color).png&text=\(index)")!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath)
        
        if let cell = cell as? ImageTableViewCell {
            
            let urlString = self.imagesUrls[indexPath.row].absoluteString
            ImageManager.sharedInstance.getImageWithURL(urlString).then({ (image) in
                if tableView.indexPathsForVisibleRows?.contains(indexPath) == true {
                    cell.exampleImageView?.image = image
                }
            })
        }
        return cell
    }
    
    
    // MARK: - Utilities
    func addURLsToFastQueue(urls:[NSURL], fromIndex:Int, toIndex:Int) {
        let indexes = (fromIndex..<toIndex).filter{ $0 < urls.count }
        indexes.forEach { index in
            let urlString = urls[index].absoluteString
            if !ImageManager.sharedInstance.haveImageWithURL(urlString) {
                ImageManager.sharedInstance.getImageWithURL(urlString)
            }
        }
    }
    
    func addURLsToSlowQueue(urls:[NSURL], fromIndex:Int, toIndex:Int) {
        let indexes = (fromIndex..<toIndex).filter{ $0 < urls.count }
        indexes.forEach { index in
            let urlString = urls[index].absoluteString
            if !ImageManager.sharedInstance.haveImageWithURL(urlString) {
                ImageManager.sharedInstance.getImageWithURL(urlString)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row > heighestDisplayedIndexPath.row {
            heighestDisplayedIndexPath = indexPath
        }
        
        let imageURLString = self.imagesUrls[indexPath.row].absoluteString
        ImageManager.sharedInstance.cancelRetrievingImageWithURL(imageURLString)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row > heighestDisplayedIndexPath.row {
            let numberOfCellsToLoadForwardFast:Int = 1
            let numberOfCellsToLoadForwardSlow:Int = 3
            
            let fastQueueStartIndex = indexPath.row + 1
            let fastQueueStopIndex = fastQueueStartIndex + numberOfCellsToLoadForwardFast
            let slowQueueStartIndex = fastQueueStopIndex + 1
            let slowQueueStopIndex = slowQueueStartIndex + numberOfCellsToLoadForwardSlow
            
            self.addURLsToFastQueue(self.imagesUrls, fromIndex: fastQueueStartIndex, toIndex: fastQueueStopIndex)
            
            self.addURLsToSlowQueue(self.imagesUrls, fromIndex: slowQueueStartIndex, toIndex: slowQueueStopIndex)
        }
    }
}
