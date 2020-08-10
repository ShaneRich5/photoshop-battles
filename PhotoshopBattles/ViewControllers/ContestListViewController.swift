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

class ContestListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        RedditClient.shared.getListingOfPosts { posts, error in
            guard error == nil else {
                debugPrint("Error present: \(error!)")
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

extension ContestListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let contestDetailViewController = storyboard?.instantiateViewController(withIdentifier: ContestDetailViewController.storyboardIdentifier) as! ContestDetailViewController
        contestDetailViewController.post = post
        navigationController!.pushViewController(contestDetailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContestListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        cell.titleLabel.text = post.title
        
        if let upvotes = post.upvotes, let author = post.author {
            cell.subtitleLabel.text = "by \(author) Upvotes: \(upvotes)"
        }
        
        if let imageView = cell.imageView {
            let imageUrl = URL(string: post.imageUrl)!
            let placeholderImage = UIImage(named: "loading")
            
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl, placeholder: placeholderImage) { result in
                switch result {
                case .success(let value):
                    post.image = value.image.pngData()
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
        
        return cell
    }
}
