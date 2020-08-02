//
//  Post.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/2/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class PostResponse: Decodable {
    var postId: String!
    var title: String!
    var imageUrl: String!
    var author: String!
    var commentCount: Int!
    var permalink: String!
    
    enum CodingKeys: String, CodingKey {
        case postId = "id"
        case title = "title"
        case imageUrl = "url"
        case author = "author"
        case permalink = "permalink"
        case commentCount = "num_comments"
    }
}
