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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    var fetchResultsController: NSFetchedResultsController<Contest>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(clearAllSavedContests))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLoadingState(isLoading: true)
        setupFlowLayout()
        fetchSavedContests()
        setLoadingState(isLoading: false)
    }
    
    func fetchSavedContests() {
        let fetchRequest: NSFetchRequest<Contest> = Contest.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
            collectionView.reloadData()
        } catch {
            debugPrint(error)
        }
    }
    
    func setLoadingState(isLoading: Bool) {
        if isLoading == true {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            label.isHidden = fetchResultsController?.fetchedObjects?.count ?? 0 > 0
        }
    }
    
    @objc fileprivate func clearAllSavedContests() {
        guard let contests = fetchResultsController.fetchedObjects else {
            print("failed to delete contests!")
            return
        }
        
        do {
            for contest in contests {
                DataController.shared.viewContext.delete(contest)
                try DataController.shared.viewContext.save()
            }
        } catch {
            debugPrint(error)
        }
    }
    
    fileprivate func setupFlowLayout() {
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fetchResultsController = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SavedContestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contest = fetchResultsController.object(at: indexPath)
        let post = contest.toPost()
        
        let contestDetailViewController = storyboard?.instantiateViewController(withIdentifier: ContestDetailViewController.storyboardIdentifier) as! ContestDetailViewController
        contestDetailViewController.post = post
        contestDetailViewController.contest = contest
        navigationController!.pushViewController(contestDetailViewController, animated: true)
    }
}

extension SavedContestViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        default:
            break
        }
    }
}

extension SavedContestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController?.fetchedObjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedContestCollectionViewCell.reuseIdentifier, for: indexPath) as! SavedContestCollectionViewCell
        
        let contest = fetchResultsController.object(at: indexPath)
        
        if let data = contest.image {
            cell.imageView.image = UIImage(data: data)
            cell.imageView.contentMode = .scaleAspectFit
        }
        
        return cell
    }
}
