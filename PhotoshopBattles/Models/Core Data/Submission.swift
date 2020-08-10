//
//  Submission.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/9/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

extension Submission {
    func toComment() -> Comment {
        let comment = Comment()

        comment.author = author
        comment.image = image
        comment.id = id
        comment.body = body
        comment.imageUrl = URL(string: imageUrl!)
        
        return comment
    }
}
