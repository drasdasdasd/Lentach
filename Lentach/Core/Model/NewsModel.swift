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
    var user = UserModel()
    
    var taskId: String?
    
    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {
        if map.mappingType == .fromJSON {
            id <- map["id"]
            description <- map["description"]
            place <- map["place"]
            date <- (map["datetime"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"))
            userId <- map["userId"]
            medias <- map["mediaIds"]
            rating <- map["rating"]
            user <- map["user"]
        } else {
            description >>> map["description"]
            medias >>> map["mediaIds"]
            userId >>> map["userId"]
            
            if let task = self.taskId {
                task >>> map["taskId"]
            }
        }
    }
    
}
