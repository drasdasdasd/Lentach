//
//  TaskCollectionViewCell.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundWhiteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundWhiteView.backgroundColor = UIColor.white
        self.backgroundWhiteView.layer.cornerRadius = 5
        self.backgroundWhiteView.layer.masksToBounds = false
        self.backgroundWhiteView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundWhiteView.layer.shadowRadius = 10
        self.backgroundWhiteView.layer.shadowOpacity = 1
        self.backgroundWhiteView.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
    }
    
}
