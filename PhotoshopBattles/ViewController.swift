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
        fetchAccessToken()
    }
    
    func fetchAccessToken() {
        RedditClient.getAccessToken(completion: { response, error in
            guard error == nil else {
                debugPrint("error: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }

            guard let accessToken = response?.accessToken, let expiresIn = response?.expiresIn else {
                debugPrint("response missing, \(response)")
                return
            }
            
            debugPrint("accessToken: \(accessToken)")
            debugPrint("expiresIn: \(expiresIn)")
        })
    }
}
