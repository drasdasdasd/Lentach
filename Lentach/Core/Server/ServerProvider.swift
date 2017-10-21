//
//  ServerProvider.swift
//  Lentach
//
//  Created by Dzianis Baidan on 20.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import Moya

enum ServerService {
    
    case listOfTask
    case listOfNews
    
}

// MARK: -
// MARK: - Moya extension

extension ServerService: TargetType {
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: "http://92.53.102.42:3000")!
    }
    
    var path: String {
        switch self {
        case .listOfTask:
            return "/api/tasks"
        case .listOfNews:
            return "/api/news"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .listOfTask, .listOfNews:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .listOfTask, .listOfNews:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
}
