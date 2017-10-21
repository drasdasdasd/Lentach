//
//  NewsWithMediaCell.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import Kingfisher

class NewsWithMediaCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var countOfMedia: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(news: NewsModel) {
        self.descriptionLabel.text = news.description
        self.countOfMedia.text = "\(news.medias.count)"
        self.updateImage(news: news)
    }
    
    func updateImage(news: NewsModel) {
        guard let media = news.medias.last else {
            return
        }
        
        if let url = media.mediaURL {
            self.mediaImageView.kf.setImage(with: URL(string: url))
            print(url)
        } else {
            self.mediaImageView.image = #imageLiteral(resourceName: "mockVideo")
        }
        
    }

}
