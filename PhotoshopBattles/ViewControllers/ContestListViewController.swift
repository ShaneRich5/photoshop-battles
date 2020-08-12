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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var posts = [Post]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshContests))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        downaloadContests()
    }
    
    @objc fileprivate func refreshContests() {
        posts = []
        downaloadContests()
    }
    
    fileprivate func showLoading(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            errorLabel.isHidden = true
            tableView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            
            errorLabel.isHidden = posts.count > 0
            tableView.isHidden = posts.count <= 0
        }
    }
    
    fileprivate func downaloadContests() {
        showLoading(isLoading: true)
        
        RedditClient.shared.getListingOfPosts { posts, error in
            guard error == nil, let posts = posts else {
                self.showLoading(isLoading: false)
                self.showErrorAlert(message: "Failed to load posts.")
                return
            }
            
            self.posts = posts
            self.showLoading(isLoading: false)
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
            
            imageView.contentMode = .scaleAspectFit
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: imageUrl,
                placeholder: placeholderImage,
                options: [
                    .processor(DownsamplingImageProcessor(size: imageView.frame.size)),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage,
                ]
            ) { result in
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
