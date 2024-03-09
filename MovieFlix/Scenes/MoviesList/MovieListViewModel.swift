//
//  MovieListViewModel.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 9/3/24.
//

import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error? = nil
    @Published var favoriteMovies: [Int] = []
    
    private var currentPage = 1
    private let favoritesKey = "FavoriteMovies"
    
    init() {
        loadFavoriteMovies()
        loadPopularMovies()
    }
    
    func loadFavoriteMovies() {
        if let favoriteMoviesIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            favoriteMovies = favoriteMoviesIDs
        }
    }
    
    func loadPopularMovies() {
        isLoading = true
        NetworkClient.shared.fetchPopularMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            //Adding a delay just to see the skeleton
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
            }
            switch result {
                case .success(let movies):
                    self.movies.append(contentsOf: movies)
                    self.currentPage += 1
                    self.updateIsFavorite()
                case .failure(let error):
                    self.error = error
            }
        }
    }
    
    func searchMovies(searchText: String) {
        isLoading = true
        if !searchText.isEmpty {
            NetworkClient.shared.searchMovies(query: searchText) { [weak self] result in
                guard let self = self else { return }
                //Adding a delay just to see the skeleton
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isLoading = false
                }
                switch result {
                    case .success(let movies):
                        clearList()
                        self.movies.append(contentsOf: movies)
                        self.updateIsFavorite()
                    case .failure(let error):
                        self.error = error
                }
            }
        } else {
            clearList()
            loadPopularMovies()
        }
    }
    
    func refreshMovies(completion: @escaping () -> Void) {
        clearList()
        loadPopularMovies()
        completion()
    }
    
    func clearList() {
        self.currentPage = 1
        self.movies.removeAll()
    }
    
    func toggleFavorite(for movie: Movie) {
        if favoriteMovies.contains(movie.id) {
            favoriteMovies.removeAll(where: { $0 == movie.id })
        } else {
            favoriteMovies.append(movie.id)
        }
        
        UserDefaults.standard.set(favoriteMovies, forKey: favoritesKey)
        
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isFavorite = favoriteMovies.contains(movie.id)
        }
    }
    
    private func updateIsFavorite() {
        for index in movies.indices {
            movies[index].isFavorite = favoriteMovies.contains(movies[index].id)
        }
    }
    
    func formattedReleaseDate(for movie: Movie) -> String? {
        if let releaseDateString = movie.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let releaseDate = dateFormatter.date(from: releaseDateString) {
                dateFormatter.dateFormat = "d MMM yyyy"
                return dateFormatter.string(from: releaseDate)
            }
        }
        return nil
    }
    
    func scaledRating(for rating: Double) -> Int {
        let scaledRating = Int(round(rating / 2.0))
        return min(max(scaledRating, 0), 5)
    }
}
