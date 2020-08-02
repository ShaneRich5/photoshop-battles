//
//  SubmissionListViewController.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/2/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation
import UIKit

class SubmissionListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PostResponse]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewWillAppear(animated)
        tableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RedditClient.shared.getListingOfPosts { posts, error in
            guard error == nil else {
                debugPrint("Error present: \(error)")
                return
            }
            guard let posts = posts else {
                debugPrint("post not loaded")
                return
            }
            
            debugPrint(posts)
            
            self.posts = posts
            self.tableView.reloadData()
        }
    }
}

extension SubmissionListViewController: UITableViewDelegate {
    
}
