//
//  FavouritesManager.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 15/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

class FavouritesManager {
    static let shared = FavouritesManager()
    let userDefaultsKey = "favourites"
    let userDefaults: UserDefaults
    var favourites: Set<String> {
        didSet {
            userDefaults.set(Array(favourites), forKey: userDefaultsKey)
        }
    }
    
    private init() {
        self.userDefaults = UserDefaults.standard
        self.favourites = Set(userDefaults.object(forKey: userDefaultsKey) as? [String] ?? [])
    }
    
    func favourite(episode: Episode) {
        favourites.insert(episode.uid)
    }
    
    func unfavourite(episode: Episode) {
        favourites.remove(episode.uid)
    }
    
    func toggleFavourite(episode: Episode) {
        isFavourited(episode: episode) ? unfavourite(episode: episode) : favourite(episode: episode)
    }
    
    func isFavourited(episode: Episode) -> Bool {
        return favourites.contains(episode.uid)
    }
}
