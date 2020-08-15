//
//  ImgurClient.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/5/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ImgurClient {
    struct HeaderKeys {
        static let AUTHORIZATION = "Authorization"
    }
    
    struct Constants {
        static let ALBUM_ENDPOINT = "/a/"
        static let GALLERY_ENDPOINT = "/gallery/"
        static let CLIENT_ID = "872f7866868a052"
    }
    
    enum Endpoint {
        case image(String)
        case album(String)
        case gallery(String)
        
        var stringValue: String {
            switch self {
            case .image(let id):
                return "https://i.imgur.com/\(id).png"
            case .album(let id):
                return "https://api.imgur.com/3/gallery/album/\(id)/images"
            case .gallery(let id):
                return "https://api.imgur.com/3/album/\(id)/images"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    static let shared = ImgurClient()
    
    fileprivate init() { }
    
    func getAlbumImage(albumId: String, _ completion: @escaping (String?, Error?) -> Void) {
        let url = Endpoint.album(albumId).url
        getImageForUrl(url, completion)
    }
    
    func getGalleryImage(galleryId: String, _ completion: @escaping (String?, Error?) -> Void) {
        let url = Endpoint.gallery(galleryId).url
        getImageForUrl(url, completion)
    }
    
    private func getImageForUrl(_ url: URL, _ completion: @escaping (String?, Error?) -> Void) {
        
        let headers: HTTPHeaders = [
            HeaderKeys.AUTHORIZATION: "Client-ID \(Constants.CLIENT_ID)"
        ]
        
        AF.request(url, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let link = json["data"][0]["link"].stringValue
                
                completion(link, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
