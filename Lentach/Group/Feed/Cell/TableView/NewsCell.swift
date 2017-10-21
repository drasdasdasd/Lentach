//
//  NewsCell.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    
    var news: NewsModel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
    }
    
    @IBAction func disLikeButtonAction(_ sender: Any) {
    }
    
}
