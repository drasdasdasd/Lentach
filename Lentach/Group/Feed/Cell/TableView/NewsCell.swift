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
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    
    var news: NewsModel!
    var voteHandler: ((_ isVote: Bool, _ news: NewsModel) -> Void)!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImageView.layer.cornerRadius = 22
        self.photoImageView.layer.masksToBounds = true
    }
    
    func set(news: NewsModel) {
        self.news = news
        self.nameLabel.text = news.user.firstName + " " + news.user.secondName
        self.descriptionLabel.text = news.description
        
        if !news.rating.isVoted {
            self.likeLabel.text = ""
            self.dislikeLabel.text = ""
        } else {
            self.likeLabel.text = "\(news.rating.up)"
            self.dislikeLabel.text = "\(news.rating.down)"
        }
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
        if !news.rating.isVoted {
            self.voteHandler(true, news)
        }
    }
    
    @IBAction func disLikeButtonAction(_ sender: Any) {
        if !news.rating.isVoted {
            self.voteHandler(false, news)
        }
    }
    
}
