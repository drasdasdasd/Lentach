//
//  MediaAddNewsCell.swift
//  Lentach
//
//  Created by Dzianis Baidan on 22.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import Photos

class MediaAddNewsCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure(view: self)
    }
    
    func set(asset: PHAsset?) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        
        if asset?.mediaType == .image {
            manager.requestImage(for: asset!, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFit, options: option, resultHandler: { (result, info) -> Void in
                self.photoImageView.image = result!
                self.configure(view: self.photoImageView)
            })
        }
    }
    
    func configure(view: UIView) {
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
    }
    
}
