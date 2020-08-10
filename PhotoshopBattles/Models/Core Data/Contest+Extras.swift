//
//  Contest.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/9/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

extension Contest {
    func toPost() -> Post {
        let post = Post()
        
        post.title = title
        post.image = image
        post.author = author
        post.postId = postId
        post.upvotes = Int(upvotes)
        post.permalink = permalink
        post.isSaved = true
        
        return post
    }
}
