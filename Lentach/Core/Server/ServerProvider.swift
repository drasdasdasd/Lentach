//
//  ServerProvider.swift
//  Lentach
//
//  Created by Dzianis Baidan on 20.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import Moya

let BaseURL = "http://92.53.102.42:3000"

enum ServerService {
    
    case vkLogin(token: String)
    case setWallet(userId: String, bitcoin: String)
    case listOfTask
    case listOfNews
    
}

// MARK: -
// MARK: - Moya extension

extension ServerService: TargetType {
    
    var task: Task {
        switch self {
        case .vkLogin(let token):
            return .requestParameters(
                parameters: ["data": token],
                encoding: URLEncoding.default)
        case .setWallet(let userId, let bitcoin):
            return .requestParameters(
                parameters: ["userId": userId, "value": bitcoin],
                encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: BaseURL)!
    }
    
    var path: String {
        switch self {
        case .vkLogin:
            return "/api/users/auth"
        case .setWallet:
            return "/api/users/setWallet"
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
        case .vkLogin, .setWallet:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .vkLogin:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
}
