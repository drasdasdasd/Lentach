//
//  NewsModel.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsModel: Mappable {
    
    var description = ""
    var place = PlaceModel()
    var date = Date()
    var userId = ""
    var id = ""
    var medias = [MediaModel]()
    var rating = RatingModel()
    
    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        place <- map["place"]
        date <- map["lat"]
        userId <- map["userId"]
        medias <- map["mediaIds"]
        rating <- map["rating"]
    }
    
}
