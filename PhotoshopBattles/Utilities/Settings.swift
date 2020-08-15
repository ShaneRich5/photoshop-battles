//
//  Settings.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/14/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class Settings {
    private let defaults = UserDefaults.standard
    
    static let shared = Settings()
    
    fileprivate init() {}
    
    static let KEY_CATEGORY = "category"
    
    func getFilter() -> RedditClient.SortByFilter {
        guard let category = defaults.string(forKey: Settings.KEY_CATEGORY), let filter = RedditClient.SortByFilter(rawValue: category) else {
            return .hot
        }
        
        return filter
    }
    
    func setFilter(filter: RedditClient.SortByFilter) {
        defaults.set(filter.rawValue, forKey: Settings.KEY_CATEGORY)
    }
}
