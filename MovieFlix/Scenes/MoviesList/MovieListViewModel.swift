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
    @Published var currentPage = 1
    
    init() {
        loadPopularMovies()
    }
    
    func loadPopularMovies() {
        isLoading = true
        NetworkClient.shared.fetchPopularMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
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
                self.isLoading = false
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
        
        // For demonstration purposes, let's simulate a delay before calling the completion closure
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
        }
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
    
}
