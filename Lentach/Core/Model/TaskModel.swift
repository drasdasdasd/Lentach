//
//  TaskModel.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import ObjectMapper

class TaskModel: Mappable {
    
    var title = ""
    var description = ""
    var date = Date()
    var sum = Double()
    var id = ""
    var place = PlaceModel()
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        date <- (map["datetime"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"))
        sum <- map["sum"]
        id <- map["id"]
        place <- map["place"]
    }
    
}
