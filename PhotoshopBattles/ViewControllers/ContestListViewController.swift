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
    
    private let refreshControl = UIRefreshControl()
    
    var posts = [Post]()
    let filters: [RedditClient.SortByFilter] = [.hot, .new, .top, .rising]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshContests(_:)), for: .valueChanged)
        
        let categoryButton: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        categoryButton.setImage(UIImage(named: "categories"), for: [])
        categoryButton.addTarget(self, action: #selector(changeCategories), for: UIControl.Event.touchUpInside)
                
        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshContests)),
            UIBarButtonItem(customView: categoryButton)
        ]
        
        let filter = Settings.shared.getFilter()
        navigationItem.title = "\(filter.rawValue.capitalize()) - Contests"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        downaloadContests()
    }
    
    @objc fileprivate func refreshContests(_ sender: Any) {
        downaloadContests(isRefreshing: true)
    }
    
    @objc fileprivate func changeCategories() {
        let alert =  UIAlertController(title: "Choose Category", message: "Select a category below.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        for filter in filters {
            let title = filter.rawValue.capitalize()

            let action = UIAlertAction(title: title, style: .default) { _ in
                Settings.shared.setFilter(filter: filter)
                self.navigationItem.title = "\(title) - Contests"
                self.downaloadContests()
            }

            alert.addAction(action)
        }

        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showLoading(isLoading: Bool, isRefreshing: Bool = false) {
        if isLoading {
            if !isRefreshing {
                activityIndicator.startAnimating()
            }
            errorLabel.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            
            errorLabel.isHidden = posts.count > 0
            tableView.isHidden = posts.count <= 0
        }
    }
    
    fileprivate func downaloadContests(isRefreshing: Bool = false) {
        showLoading(isLoading: true, isRefreshing: isRefreshing)
        
        if !isRefreshing {
            posts = []
            tableView.reloadData()
        }
        
        let filter = Settings.shared.getFilter()
        
        RedditClient.shared.getListingOfPosts(filter: filter) { posts, error in
            guard error == nil, let posts = posts else {
                self.showLoading(isLoading: false)
                self.showErrorAlert(message: "Failed to load posts.")
                self.refreshControl.endRefreshing()
                return
            }
            
            self.posts = posts
            self.showLoading(isLoading: false)
            self.refreshControl.endRefreshing()
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
            let placeholderImage = UIImage(named: "placeholder")
            
            imageView.contentMode = .scaleAspectFit
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: imageUrl,
                placeholder: placeholderImage,
                options: [
//                    .processor(DownsamplingImageProcessor(size: imageView.frame.size)),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage,
                ]
            ) { result in
                switch result {
                case .success(let value):
                    if post.image == nil {
                        post.image = value.image.pngData()
                    }
                case .failure(let error):
                    break
                }
            }
        }
        
        return cell
    }
}
