//
//  SubmissionListViewController.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/2/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

class SubmissionListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PostResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        RedditClient.shared.getListingOfPosts { posts, error in
            guard error == nil else {
                debugPrint("Error present: \(error)")
                return
            }
            guard let posts = posts else {
                debugPrint("post not loaded")
                return
            }
            
            self.posts = posts
            self.tableView.reloadData()
        }
    }
}

extension SubmissionListViewController: UITableViewDelegate {
    
}

extension SubmissionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        cell.titleLabel.text = post.title
        
        if let upvotes = post.upvotes, let commentCount = post.commentCount {
            cell.subtitleLabel.text = "Upvotes: \(upvotes) Comments: \(commentCount)"
        }
        
        if let imageView = cell.imageView {
            let imageUrl = URL(string: post.imageUrl)!
            let placeholderImage = UIImage(named: "loading")
            
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl, placeholder: placeholderImage)
        }
        
        return cell
    }
}
