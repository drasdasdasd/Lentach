//
//  PlaceModel.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import ObjectMapper

class PlaceModel: Mappable {
    
    var lat = Double()
    var long = Double()
    
    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {
        lat <- map["lat"]
        long <- map["long"]
    }
    
}
