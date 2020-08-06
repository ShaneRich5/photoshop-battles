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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var post: Post!
    var comments = [Comment]()
    
    var fetchingCommentUrls: [String: String] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl = URL(string: post.imageUrl)!
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl)
        
        collectionView.dataSource = self
        
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
//                            print("comments success album \(albumId) imageUrl: \(self.comments.map { $0.imageUrl })")
                            self.fetchingCommentUrls[urlString] = "success"
                        } else {
                            self.fetchingCommentUrls[urlString] = "failed"
                        }
//                        print("comments failed album \(albumId) imageUrl: \(self.comments.map { $0.imageUrl })")
                        
                    }
                } else if urlString.contains(ImgurClient.Constants.GALLERY_ENDPOINT) {
                    let galleryId = urlString.components(separatedBy: ImgurClient.Constants.GALLERY_ENDPOINT).last!
                    self.fetchingCommentUrls[urlString] = "loading"
                    
                    ImgurClient.shared.getGalleryImage(galleryId: galleryId) { link, error in
                        if let link = link {
                            self.comments[index].imageUrl = URL(string: link)!
                            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                            print("comments success gallery \(galleryId) imageUrl: \(self.comments.map { $0.imageUrl })")
                            
                            self.fetchingCommentUrls[urlString] = "success"
//                            if urlString == "https://imgur.com/gallery/5e5lOP" {
//                                print("url: \(index) \(url!) \(urlString.components(separatedBy: ImgurClient.Constants.GALLERY_ENDPOINT).last!)")
//                            }
                            
//                            print("comments gallery \(galleryId) imageUrl: \(self.comments.map { $0.imageUrl })")
                        } else {
                            self.fetchingCommentUrls[urlString] = "failed"
                        }
                        
                        print("comments failed gallery \(galleryId) imageUrl: \(self.comments.map { $0.imageUrl })")
                    }
                } else {
                    comment.imageUrl = URL(string: "\(urlString).png")!
                }
            }
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
//        cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "loading"), completionHandler: )
        
        return cell
    }
    
    
}
