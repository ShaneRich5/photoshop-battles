//
//  ContestDetailViewController.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/3/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

class ContestDetailViewController: ViewController {
    static let storyboardIdentifier = "ContestDetailViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var post: PostResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl = URL(string: post.imageUrl)!
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl)
        
        print(post.imageUrl)
        print(post.permalink)
    }
}
