//
//  StoryboardExtension.swift
//  Fjuul
//
//  Created by Dzianis Baidan on 23.05.17.
//  Copyright © 2017 Fjuul Vision Oy. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
}

enum Storyboard: String {
    
    case entry = "Entry"
    case bitcoin = "Bitcoin"
    case feed = "FeedStoryboard"
    case camera = "Camera"
    case task = "Task"
    case newsAdded = "NewsAdded"
    case chooseLocation = "ChooseLocation"

    var filename: String {
        return rawValue
    }
    
}
