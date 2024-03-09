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
    private var currentPage = 1
    
    init() {
        loadPopularMovies()
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
                        self.movies.append(contentsOf: movies)
                    case .failure(let error):
                        self.error = error
                }
            }
        } else {
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
        // ...
    }
    
    func formattedReleaseDate(for movie: Movie) -> String? {
        if let releaseDateString = movie.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Update the format to match your string date format
            if let releaseDate = dateFormatter.date(from: releaseDateString) {
                dateFormatter.dateFormat = "d MMM yyyy"
                return dateFormatter.string(from: releaseDate)
            }
        }
        return nil
    }
    
    func scaledRating(for rating: Double) -> Int {
        let scaledRating = Int(round(rating / 2.0))
        return min(max(scaledRating, 0), 5) // Ensure the scaled rating is within the range [0, 5]
    }

}
