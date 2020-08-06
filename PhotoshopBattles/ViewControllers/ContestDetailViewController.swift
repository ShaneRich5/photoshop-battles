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
    
    var fetchingCommentUrls: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl = URL(string: post.imageUrl)!
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        RedditClient.shared.getListingOfComments(permalink: post.permalink, handleCommentsLoaded(comments:error:))
    }
    
    func handleCommentsLoaded(comments: [Comment]?, error: Error?) {
        guard error == nil else {
            debugPrint("Error present: \(error)")
            return
        }

        guard let comments = comments else {
            debugPrint("comments not loaded")
            return
        }

        self.comments = comments.filter { $0.url != nil }
        collectionView.reloadData()
        
        print("comments url: \(self.comments.map { $0.url })")
        
        for (index, comment) in self.comments.enumerated() {
            let url = comment.url

            if let urlString = url?.absoluteString  {
                let hasExtension = urlString.hasSuffix(".png") || urlString.hasSuffix(".jpg") || urlString.hasSuffix(".gif")
                
                if hasExtension {
                    comment.imageUrl = URL(string: urlString)!
                } else if urlString.contains(ImgurClient.Constants.ALBUM_ENDPOINT) {
                    self.fetchingCommentUrls[urlString] = "loading"
                    
                    let albumId = urlString.components(separatedBy: ImgurClient.Constants.ALBUM_ENDPOINT).last!
                    ImgurClient.shared.getAlbumImage(albumId: albumId) { link, error in
                        if let link = link {
                            self.comments[index].imageUrl = URL(string: link)!
                            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                            self.fetchingCommentUrls[urlString] = "success"
                        } else {
                            self.fetchingCommentUrls[urlString] = "failed"
                        }
                        
                    }
                } else if urlString.contains(ImgurClient.Constants.GALLERY_ENDPOINT) {
                    let galleryId = urlString.components(separatedBy: ImgurClient.Constants.GALLERY_ENDPOINT).last!
                    self.fetchingCommentUrls[urlString] = "loading"
                    
                    ImgurClient.shared.getGalleryImage(galleryId: galleryId) { link, error in
                        if let link = link {
                            self.comments[index].imageUrl = URL(string: link)!
                            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                            self.fetchingCommentUrls[urlString] = "success"
                        } else {
                            self.fetchingCommentUrls[urlString] = "failed"
                        }
                    }
                } else {
                    comment.imageUrl = URL(string: "\(urlString).png")!
                }
            }
        }
    }
}

extension ContestDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comment = comments[indexPath.row]
        if let imageUrl = comment.imageUrl {
            imageView.kf.setImage(with: imageUrl)
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
        
        if let imageUrl = comment.imageUrl {
            print("imageUrl: \(imageUrl)")
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loading")) {result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
                
            }
        }
        
        return cell
    }
    
    
}
