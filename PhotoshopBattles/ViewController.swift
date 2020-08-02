//
//  ViewController.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 7/30/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        RedditClient.getAccessToken()
        
        RedditClient.getAccessToken()
        
//        let urlString = "https://www.reddit.com/r/photoshopbattles.json"
//        AF.request(urlString).response { response in
//            let json = try? JSON(data: response.data!)
//            debugPrint(json)
//        }
    }


}

