//
//  ImageListImageTableViewCell.swift
//  FlicPic
//
//  Created by Simon Jensen on 27/03/17.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit

class ImageListImageTableViewCell: UITableViewCell {
    
    @IBOutlet var bigImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
