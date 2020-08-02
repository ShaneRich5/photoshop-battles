//
//  AccessTokenResponse.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/1/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class AccessTokenResponse: Decodable {
    var accessToken: String!
    var tokenType: String!
    var deviceId: String!
    var expiresIn: Int!
    var scope: String!

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case deviceId = "device_id"
    }
}
