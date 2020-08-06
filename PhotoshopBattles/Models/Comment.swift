//
//  Comment.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/3/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class Comment: Decodable {
    var author: String!
    var body: String!
    var createdAt: Date!
    
    var imageUrl: URL!
    
    var url: URL? {
        get {
//            print("body \(body)")
            return body?.extractURLs().first
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case body = "body"
        case author = "author"
        case createdAt = "created"
    }
}
