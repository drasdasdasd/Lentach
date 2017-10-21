//
//  MediaCreator.swift
//  Lentach
//
//  Created by Dzianis Baidan on 22.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import MWPhotoBrowser

class MediaCreator {
    
    func browser(news: NewsModel) -> MWPhotoBrowser {
        let photos = self.create(news: news)
        let browser = MWPhotoBrowser(photos: photos)
        return browser!
    }
    
    func create(news: NewsModel) -> [MWPhoto] {
        var photos = [MWPhoto]()
        for media in news.medias {
            if media.type == "video" {
                let med = MWPhoto(videoURL: URL(string: media.mediaURL ?? ""))
                photos.append(med!)
            } else {
                let photo = MWPhoto(url: URL(string: media.mediaURL ?? ""))
                photos.append(photo!)
            }
        }
        return photos
    }

}
