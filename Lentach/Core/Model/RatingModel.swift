//
//  RatingModel.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import ObjectMapper

class RatingModel: Mappable {
    
    var up = 0
    var down = 0
    var isVoted = false
    var isLiked = false
    
    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {
        up <- map["up"]
        down <- map["down"]
        isVoted <- map["isVoted"]
        isLiked <- map["isLiked"]
    }
    
}
