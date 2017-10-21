//
//  UserDefaultsManager.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDefaultsManager {

    func save(user: String) {
        UserDefaults.standard.set(user, forKey: "user")
    }
    
    func getUser() -> String? {
        if let user = UserDefaults.standard.object(forKey: "user") as? String {
            return user
        }
        return nil
    }
    
}
