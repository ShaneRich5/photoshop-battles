//
//  RedditClient+Extras.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/1/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

extension RedditClient {
    struct ParameterKeys {
        static let GRANT_TYPE = "grant_type"
        static let DEVICE_ID = "device_id"
    }
    
    struct HeaderKeys {
        static let CONTENT_TYPE = "Content-Type"
        static let AUTHORIZATION = "Authorization"
    }
    
    struct Constants {
        static let BASE_URL = "https://www.reddit.com"
        static let CLIENT_ID = "ArB2sddOUAh0CA"
        static let CLIENT_SECRET = ""
        static let GRANT_TYPE = "https://oauth.reddit.com/grants/installed_client"
        static let DEVICE_ID = "DO_NOT_TRACK_THIS_DEVICE"
        static let FORM_URL_ENCODED = "application/x-www-form-urlencoded"
    }
    
    enum SortByFilter: String {
        case hot = "hot"
        case new = "new"
        case top = "top"
        case rising = "rising"
    }
    
    enum Endpoint {
        case accessToken
        case subreddit(SortByFilter)
        case comments(String)
        
        var stringValue: String {
            switch self {
            case .accessToken:
                return "\(Constants.BASE_URL)/api/v1/access_token"
            case .subreddit(let filter):
                return "\(Constants.BASE_URL)/r/photoshopbattles/\(filter.rawValue).json"
            case .comments(let permalink):
                return "\(Constants.BASE_URL)\(permalink).json"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
