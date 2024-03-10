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
    
    init(movie: Movie) {
        self.movie = movie
        fetchMovieDetails()
    }
    
    var formattedGenres: String {
        guard let genres = movie.genres else { return "" }
        return genres.map { $0.name }.joined(separator: ", ")
    }
    
    func fetchMovieDetails() {
        isLoading = true
        NetworkClient.shared.getMovieDetails(movieID: movie.id) { [weak self] result in
            guard let self = self else { return }
            //Adding a delay just to see the skeleton
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
            }
            switch result {
                case .success(let movie):
                    self.movie = movie
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
        if movie.isFavorite {
            UserDefaults.standard.set(true, forKey: "\(movie.id)")
        } else {
            UserDefaults.standard.removeObject(forKey: "\(movie.id)")
        }
    }
    
    func scaledRating() -> Int {
        let scaledRating = Int(round(movie.voteAverage / 2.0))
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
