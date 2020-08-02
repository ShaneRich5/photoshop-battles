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
    struct Constants {
        static let BASE_URL = "https://www.reddit.com/api/v1/access_token"
        static let CLIENT_ID = "ArB2sddOUAh0CA"
        static let CLIENT_SECRET = ""
        static let GRANT_TYPE = "https://oauth.reddit.com/grants/installed_client"
        static let DEVICE_ID = "DO_NOT_TRACK_THIS_DEVICE"
    }
    
    enum Endpoint {
        case accessToken
        
        var stringValue: String {
            switch self {
            case .accessToken:
                return Constants.BASE_URL
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getAccessToken(completion: @escaping (AccessTokenResponse?, Error?) -> Void) {
        let url = Endpoint.accessToken.url
        
        let loginString = String(format: "%@:%@", Constants.CLIENT_ID, Constants.CLIENT_SECRET)
        let loginData = loginString.data(using: String.Encoding.utf8)! as NSData
        let encodedClientIDAndPassword = loginData.base64EncodedString()

        let authorizationString = "Basic \(encodedClientIDAndPassword)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: Parameters = [
            "grant_type": Constants.GRANT_TYPE,
            "device_id": Constants.DEVICE_ID
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": authorizationString
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    let accessTokenResponse = try decoder.decode(AccessTokenResponse.self, from: response.data!)
                    completion(accessTokenResponse, nil)
                } catch {
                    completion(nil, error)
                }
                break
            case .failure:
                completion(nil, response.error)
                break
            }

//            let json = JSON(response.value!)
//            print("=== getAccessTokenTest ===")
//            debugPrint(String(data: response.data!, encoding: .utf8))
//            debugPrint(json["access_token"].type)
        }
    }
}
