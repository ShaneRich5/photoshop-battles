//
//  RedditClient.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/1/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RedditClient {
    static let shared = RedditClient()
    
    public var accessToken: String?
    
    fileprivate init() { }
    
    func getAccessToken(completion: @escaping (AccessTokenResponse?, Error?) -> Void) {
        let url = Endpoint.accessToken.url
        
        let loginString = String(format: "%@:%@", Constants.CLIENT_ID, Constants.CLIENT_SECRET)
        let loginData = loginString.data(using: String.Encoding.utf8)! as NSData
        let encodedClientIDAndPassword = loginData.base64EncodedString()

        let authorizationString = "Basic \(encodedClientIDAndPassword)"
        
        let parameters: Parameters = [
            ParameterKeys.GRANT_TYPE: Constants.GRANT_TYPE,
            ParameterKeys.DEVICE_ID: Constants.DEVICE_ID
        ]
        
        let headers: HTTPHeaders = [
            HeaderKeys.CONTENT_TYPE: Constants.FORM_URL_ENCODED,
            HeaderKeys.AUTHORIZATION: authorizationString
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    let accessTokenResponse = try decoder.decode(AccessTokenResponse.self, from: response.data!)
                    
                    self.accessToken = accessTokenResponse.accessToken
                    
                    completion(accessTokenResponse, nil)
                } catch {
                    completion(nil, error)
                }
                break
            case .failure:
                completion(nil, response.error)
                break
            }
        }
    }
    
    func getListingOfPosts(filter: SortByFilter = SortByFilter.hot, _ completion: @escaping ([Post]?, Error?) -> Void) {
        let url = Endpoint.subreddit(filter).url
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let json = JSON(value)
                    let decoder = JSONDecoder()
                    
                    let postData: [Post] = try json["data"]["children"].arrayValue.filter { children in
                        return children["data"]["post_hint"].stringValue == "image"
                    }.map { children in
                        let data = children["data"]
                        
                        // should filter nil results from try? rather than using try!
                        return try decoder.decode(Post.self, from: data.rawData())
                    }
                    
                    completion(postData, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                debugPrint(error)
                completion(nil, error)
            }
        }
    }
    
    func getListingOfComments(permalink: String, _ completion: @escaping ([Comment]?, Error?) -> Void) {
        let url = Endpoint.comments(permalink).url
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let json = JSON(value)
                    let decoder = JSONDecoder()
                    
                    print("children count: \(json[1]["data"]["children"].arrayValue.count)")
                    
                    let comments: [Comment] = try json[1]["data"]["children"].arrayValue.map { children in
                        let data = children["data"]
                        return try decoder.decode(Comment.self, from: data.rawData())
                    }.filter { comment in
                        return comment.url != nil
                    }
                    
                    completion(comments, nil)
                } catch {
                    completion(nil, error)
                }
            case.failure(let error):
                completion(nil, error)
            }
        }
    }
}
