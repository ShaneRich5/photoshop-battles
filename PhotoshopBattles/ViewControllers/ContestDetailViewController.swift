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
    
    var post: Post!
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl = URL(string: post.imageUrl)!
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl)
        
        collectionView.dataSource = self
        
        RedditClient.shared.getListingOfComments(permalink: post.permalink) { comments, error in
            guard error == nil else {
                debugPrint("Error present: \(error)")
                return
            }

            guard let comments = comments else {
                debugPrint("comments not loaded")
                return
            }

            self.comments = comments
            
//            print("comments: \(comments.map { $0.body.extractURLs().first })")
            print("comments url: \(comments.map { $0.url })")
            print("comments imageUrl: \(comments.map { $0.imageUrl })")
        }
    }
}

extension ContestDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubmissionCollectionViewCell.reuseIdentifier, for: indexPath) as! SubmissionCollectionViewCell

        let comment = comments[indexPath.row]
        let url = comment.url!
        
        cell.imageView.kf.indicatorType = .activity
//        cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "loading"), completionHandler: )
        
        return cell
    }
    
    
}
