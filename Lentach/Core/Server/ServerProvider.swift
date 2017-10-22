//
//  ServerProvider.swift
//  Lentach
//
//  Created by Dzianis Baidan on 20.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import Foundation
import Moya

let BaseURL = "https://wavemeup.me"

enum ServerService {
    
    case vkLogin(token: String)
    case setWallet(userId: String, bitcoin: String, token: String)
    case listOfTask
    case listOfNews
    case vote(isUp: Bool, newsId: String)
    case loadVideo(data: Data)
    case loadImage(data: Data)
    case uploadNews(news: [String: Any])
    
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
        case .listOfNews:
            return .requestParameters(
                parameters: ["filter": ["include": ["task", "user"]]],
                encoding: URLEncoding.default)
        case .setWallet(let userId, let bitcoin, _):
            return .requestParameters(
                parameters: ["userId": userId, "value": bitcoin],
                encoding: URLEncoding.default)
        case .vote(_, let newsId):
            return .requestParameters(
                parameters: ["id": newsId],
                encoding: URLEncoding.default)
        case .loadVideo(let data):
            let formData: [MultipartFormData] = [MultipartFormData(
                provider: .data(data),
                name: "file",
                fileName: "video.mp4",
                mimeType:"video/mp4")]
            return .uploadMultipart(formData)
        case .loadImage(let data):
            let formData: [MultipartFormData] = [MultipartFormData(
                provider: .data(data),
                name: "file",
                fileName: "image.jpg",
                mimeType: "image/jpeg")]
            return .uploadMultipart(formData)
        case .uploadNews(let parameters):
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .setWallet, .vote, .listOfNews, .uploadNews:
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
        case .uploadNews:
            return "/api/news"
        case .vote(let isUp, _):
            if isUp {
                return "/api/news/voteUp"
            } else {
                return "/api/news/voteDown"
            }
        case .loadVideo, .loadImage:
            return "/api/containers/media/upload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .listOfTask, .listOfNews:
            return .get
        case .vkLogin, .setWallet, .loadVideo, .loadImage, .uploadNews:
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
        case .vkLogin, .uploadNews:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
}
