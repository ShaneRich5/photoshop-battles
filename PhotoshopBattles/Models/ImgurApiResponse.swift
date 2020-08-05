//
//  ImgurResponse.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/5/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class ImgurApiResponse: Decodable {
    var data: [ImgurImageApiResponse]!
}

class ImgurImageApiResponse: Decodable {
    var id: String!
    var link: String!
}
