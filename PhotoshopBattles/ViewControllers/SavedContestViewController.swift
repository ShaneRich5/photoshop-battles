//
//  SavedContestViewController.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/7/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit
import CoreData

class SavedContestViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchResultsController: NSFetchedResultsController<Contest>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
