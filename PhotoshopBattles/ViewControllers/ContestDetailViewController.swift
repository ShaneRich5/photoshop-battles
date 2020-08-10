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
import CoreData

class ContestDetailViewController: ViewController {
    static let storyboardIdentifier = "ContestDetailViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var post: Post!
    var contest: Contest?
    var comments = [Comment]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveContest))
    }
    
    @objc func saveContest() {
        do {
            
            let contest = Contest(context: DataController.shared.viewContext)
            contest.image = post.image
            contest.postId = post.postId
            contest.permalink = post.permalink
            contest.createDate = Date()
            contest.submissions = []
            
            let commentWithImages = comments.filter { comment in !comment.isPost }
                
            commentWithImages.forEach { comment in
                let submission = Submission(context: DataController.shared.viewContext)
                
                submission.id = comment.id
                submission.image = comment.image
                submission.author = comment.author
                submission.createDate = Date()
                submission.imageUrl = comment.imageUrl.absoluteString
                
                submission.contest = contest
            }
            
            try DataController.shared.viewContext.save()
        } catch {
            debugPrint(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if post.isSaved == true, contest != nil, let data = post.image {
            imageView.image = UIImage(data: data)
            
            fetchSavedComments()
        } else {
            let imageUrl = URL(string: post.imageUrl)!
            
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl)
            
            RedditClient.shared.getListingOfComments(permalink: post.permalink, handleCommentsLoaded(commentsFromResponse:error:))
        }
        
        navigationItem.title = post.title
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetchSavedComments() {
        do {
            let fetchRequest: NSFetchRequest<Submission> = Submission.fetchRequest()
        
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "contest == %@", contest!)
            
            let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: post!.postId)

            try fetchResultsController.performFetch()
            
            let submissions = fetchResultsController.fetchedObjects!
            
            comments = submissions.map { submission in submission.toComment() }
            collectionView.reloadData()
        } catch {
            debugPrint(error)
        }
    }
    
    func handleCommentsLoaded(commentsFromResponse: [Comment]?, error: Error?) {
        guard error == nil else {
            debugPrint("Error present: \(error!)")
            return
        }

        guard let commentsFromResponse = commentsFromResponse else {
            debugPrint("comments not loaded")
            return
        }

        comments = commentsFromResponse.filter { $0.url != nil }
        comments.insert(post.toComment(), at: 0)
        collectionView.reloadData()
        
        for (index, comment) in comments.enumerated() {
            let url = comment.url

            if let urlString = url?.absoluteString  {
                let hasExtension = urlString.hasSuffix(".png") || urlString.hasSuffix(".jpg") || urlString.hasSuffix(".gif")
                
                if hasExtension {
                    comment.imageUrl = URL(string: urlString)!
                } else if urlString.contains(ImgurClient.Constants.ALBUM_ENDPOINT) {
                    
                    let albumId = urlString.components(separatedBy: ImgurClient.Constants.ALBUM_ENDPOINT).last!
                    
                    ImgurClient.shared.getAlbumImage(albumId: albumId) { link, error in
                        if let link = link {
                            self.comments[index].imageUrl = URL(string: link)!
                            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                        }
                        
                    }
                } else if urlString.contains(ImgurClient.Constants.GALLERY_ENDPOINT) {
                    let galleryId = urlString.components(separatedBy: ImgurClient.Constants.GALLERY_ENDPOINT).last!
                    
                    ImgurClient.shared.getGalleryImage(galleryId: galleryId) { link, error in
                        if let link = link {
                            self.comments[index].imageUrl = URL(string: link)!
                            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
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
        
        if comment.isPost == true {
            navigationItem.title = comment.body
        } else if let author = comment.author {
            navigationItem.title = "by \(author)"
        }
        
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
        
        if let image = comment.image {
            cell.imageView.image = UIImage(data: image)
        } else if let imageUrl = comment.imageUrl {
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loading")) {result in
                switch result {
                case .success(let value):
                    comment.image = value.image.pngData()
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        
        return cell
    }
    
    
}
