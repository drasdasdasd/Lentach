//
//  MediaModel.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import ObjectMapper

class MediaModel: Mappable {
    
    var type = ""
    var id = ""
    
    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {
        type <- map["type"]
        id <- map["id"]
    }
    
    var mediaURL: String? {
        if self.type == "video" {
            return nil
        } else {
            return BaseURL + "/static/media/" + self.id
        }
    }
    
}
