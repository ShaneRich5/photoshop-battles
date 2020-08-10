//
//  Comment.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/3/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class Comment: Decodable {
    var id: String!
    var author: String!
    var body: String!
    
    var imageUrl: URL!
    var image: Data?
    var isPost = false
    
    var url: URL? {
        get {
            return body?.extractURLs().first
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "name"
        case body = "body"
        case author = "author"
    }
}
