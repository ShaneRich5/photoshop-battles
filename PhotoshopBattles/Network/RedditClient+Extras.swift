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
        static let BASE_URL = "https://www.reddit.com/api/v1/access_token"
        static let CLIENT_ID = "ArB2sddOUAh0CA"
        static let CLIENT_SECRET = ""
        static let GRANT_TYPE = "https://oauth.reddit.com/grants/installed_client"
        static let DEVICE_ID = "DO_NOT_TRACK_THIS_DEVICE"
        static let FORM_URL_ENCODED = "application/x-www-form-urlencoded"
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
}
