//
//  Post.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/2/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class PostResponse: Decodable {
    var upvotes: Int!
    var title: String!
    var author: String!
    var postId: String!
    var imageUrl: String!
    var commentCount: Int!
    var permalink: String!
    
    enum CodingKeys: String, CodingKey {
        case postId = "id"
        case upvotes = "ups"
        case title = "title"
        case imageUrl = "url"
        case author = "author"
        case permalink = "permalink"
        case commentCount = "num_comments"
    }
}
