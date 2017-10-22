//
//  DateExtension.swift
//  Lentach
//
//  Created by Dzianis Baidan on 22.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation

extension Date {
    
    func getStringTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd в hh:mm"
        return dateFormatter.string(from: self)
    }
    
    
}
