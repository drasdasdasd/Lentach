//
//  UserModel.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: Mappable {
    
    var earned = Double()
    var posts = 0
    var imgSrc = ""
    var firstName = "Анонимный"
    var secondName = "Пользователь"
    var btcWallet = ""
    var vkId = ""
    var id = ""
    var token = ""
    
    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {
        earned <- map["earned"]
        posts <- map["posts"]
        imgSrc <- map["imgSrc"]
        firstName <- map["first_name"]
        secondName <- map["last_name"]
        btcWallet <- map["btc_wallet"]
        vkId <- map["username"]
        id <- map["id"]
        token <- map["accessToken"]
    }
    
}
