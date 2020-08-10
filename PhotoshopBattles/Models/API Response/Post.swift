//
//  Post.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/2/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class Post: Decodable {
    var upvotes: Int!
    var title: String!
    var author: String!
    var postId: String!
    var imageUrl: String!
    var permalink: String!
    var image: Data?
    var isSaved = false
    
    enum CodingKeys: String, CodingKey {
        case postId = "id"
        case title = "title"
        case upvotes = "ups"
        case imageUrl = "url"
        case author = "author"
        case permalink = "permalink"
    }
    
    func toComment() {
        let comment = Comment()
        
        comment.id = post.postId
        comment.body = post.body
        comment.image = post.image
        comment.author = post.author
        comment.imageUrl = post.imageUrl
        
        return comment
    }
}
