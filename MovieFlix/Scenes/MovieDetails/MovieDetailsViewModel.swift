//
//  MovieDetailsViewModel.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 10/3/24.
//

import Foundation

class MovieDetailsViewModel: ObservableObject {
    @Published var movie: Movie
    @Published var isLoading = false
    @Published var error: Error? = nil
    @Published var similarMovies: [Movie]?
    
    private let favoriteManager = FavoriteManager()
    
    init(movie: Movie) {
        self.movie = movie
        fetchMovieDetails()
        fetchSimilarMovies()
    }
    
    var formattedGenres: String {
        guard let genres = movie.genres else { return "" }
        return genres.map { $0.name }.joined(separator: ", ")
    }
    
    func fetchMovieDetails() {
        isLoading = true
        NetworkClient.shared.getMovieDetails(movieID: movie.id) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
                case .success(let movie):
                    self.movie = movie
                    self.updateIsFavorite()
                case .failure(let error):
                    self.error = error
            }
        }
    }
    
    func fetchSimilarMovies() {
        isLoading = true
        NetworkClient.shared.fetchSimilarMovies(movieID: movie.id) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
                case .success(let movies):
                    self.similarMovies = movies
                case .failure(let error):
                    self.error = error
            }
        }
    }
    
    func formattedReleaseDate() -> String? {
        if let releaseDateString = movie.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let releaseDate = dateFormatter.date(from: releaseDateString) {
                dateFormatter.dateFormat = "d MMMM yyyy"
                return dateFormatter.string(from: releaseDate)
            }
        }
        return nil
    }
    
    func favoriteTapped() {
        movie.isFavorite.toggle()
        favoriteManager.toggleFavorite(movieId: movie.id, in: favoriteManager.loadFavoriteMovies())
    }
    
    func updateIsFavorite() {
        movie.isFavorite = favoriteManager.isFavorite(movieId: movie.id, in: favoriteManager.loadFavoriteMovies())
    }
    
    func scaledRating() -> Int {
        let scaledRating = Int(round((movie.voteAverage ?? 0) / 2.0))
        return min(max(scaledRating, 0), 5)
    }
    
    func formattedActors() -> String {
        guard let credits = movie.credits, let cast = credits.cast else {
            return ""
        }
        
        let filteredCast = cast.filter { $0.knownForDepartment == "Acting" }
        return filteredCast.compactMap { $0.name }.joined(separator: ", ")
    }
}
