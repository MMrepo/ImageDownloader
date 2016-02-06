//
//  ImageTableViewCell.swift
//  ImageDownloader
//
//  Created by Mateusz Małek on 30.01.2016.
//  Copyright © 2016 Mateusz Małek. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var exampleImageView: UIImageView!
    
    override func prepareForReuse() {
        exampleImageView.image = nil
    }
}
