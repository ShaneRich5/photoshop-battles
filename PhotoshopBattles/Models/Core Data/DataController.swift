//
//  DataController.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/7/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import CoreData

class DataController {
    public static let modelName = "PhotoshopBattles"
    
    let persistentContainer: NSPersistentContainer!
    let backgroundContext: NSManagedObjectContext!

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static let shared = DataController(modelName: modelName)
    
    fileprivate init (modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            completion?()
        }
    }
}
