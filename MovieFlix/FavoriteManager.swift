//
//  FavoriteManager.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 11/3/24.
//

import Foundation

class FavoriteManager {
    private let favoritesKey = "FavoriteMovies"

    func loadFavoriteMovies() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }

    func saveFavoriteMovies(_ favoriteMovies: [Int]) {
        UserDefaults.standard.set(favoriteMovies, forKey: favoritesKey)
    }

    func toggleFavorite(movieId: Int, in favorites: [Int]) -> [Int] {
        var updatedFavorites = favorites
        if updatedFavorites.contains(movieId) {
            updatedFavorites.removeAll(where: { $0 == movieId })
        } else {
            updatedFavorites.append(movieId)
        }
        saveFavoriteMovies(updatedFavorites)
        return updatedFavorites
    }

    func isFavorite(movieId: Int, in favorites: [Int]) -> Bool {
        return favorites.contains(movieId)
    }
}
