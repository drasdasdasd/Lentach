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
    case setWallet(userId: String, bitcoin: String, token: String)
    case listOfTask
    case listOfNews
    case vote(isUp: Bool, newsId: String, token: String)
    
}

// MARK: -
// MARK: - Moya extension

extension ServerService: TargetType {
    
    var task: Task {
        switch self {
        case .vkLogin(let token):
            return .requestParameters(
                parameters: ["access_token": token],
                encoding: URLEncoding.default)
        case .setWallet(let userId, let bitcoin, _):
            return .requestParameters(
                parameters: ["userId": userId, "value": bitcoin],
                encoding: URLEncoding.default)
        case .vote(_, let newsId, _):
            return .requestParameters(
                parameters: ["id": newsId],
                encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .setWallet, .vote, .listOfNews:
            return ["Authorization": UserDefaultsManager().getUser()?.token ?? ""]
        default: return nil
        }
    }
    
    var baseURL: URL {
        return URL(string: BaseURL)!
    }
    
    var path: String {
        switch self {
        case .vkLogin:
            return "/api/users/auth/token"
        case .setWallet:
            return "/api/users/setWallet"
        case .listOfTask:
            return "/api/tasks"
        case .listOfNews:
            return "/api/news"
        case .vote(let isUp, _, _):
            if isUp {
                return "/api/news/voteUp"
            } else {
                return "/api/news/voteDown"
            }
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .listOfTask, .listOfNews:
            return .get
        case .vkLogin, .setWallet:
            return .post
        case .vote:
            return .put
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
