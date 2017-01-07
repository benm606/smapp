//
//  PostTableViewCell.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/6/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.alpha = 0
        self.contentTextView.alpha = 0
        self.postImageView.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
