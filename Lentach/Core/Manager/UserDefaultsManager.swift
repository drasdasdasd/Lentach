//
//  UserDefaultsManager.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class UserDefaultsManager {

    func save(user: String) {
        UserDefaults.standard.set(user, forKey: "user")
    }
    
    func getUser() -> UserModel? {
        if let user = UserDefaults.standard.object(forKey: "user") as? String {
            let user = Mapper<UserModel>().map(JSONString: user)
            return user
        }
        return nil
    }
    
}
