//
//  NetworkClient.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 8/3/24.
//

import Foundation
import Alamofire

class NetworkClient {
    static let shared = NetworkClient()
    
    private let apiKey: String
    
    private init() {
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            fatalError("API_KEY not found in environment variables")
        }
        self.apiKey = apiKey
    }
    
    func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "page": page
        ]
        
        performRequest(urlString: urlString, parameters: parameters, completion: completion)
    }
    
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/search/movie"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "query": query,
            "include_adult": true,
            "language": "en-US",
            "page": 1
        ]
        
        performRequest(urlString: urlString, parameters: parameters, completion: completion)
    }
    
    func getMovieDetails(movieID: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "language": "en-US",
            "append_to_response": "credits,reviews"
        ]
        
        AF.request(urlString, parameters: parameters)
            .validate()
            .responseDecodable(of: Movie.self) { response in
                switch response.result {
                    case .success(let movieDetailResponse):
                        completion(.success(movieDetailResponse))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
    
    func fetchSimilarMovies(movieID: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/similar"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "language": "en-US",
            "page": 1
        ]
        
        AF.request(urlString, parameters: parameters)
            .validate()
            .responseDecodable(of: MoviesResponse.self) { response in
                switch response.result {
                    case .success(let movieResults):
                        completion(.success(movieResults.results))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
    
    private func performRequest(urlString: String, parameters: [String: Any], completion: @escaping (Result<[Movie], Error>) -> Void) {
        AF.request(urlString, parameters: parameters)
            .validate()
            .responseDecodable(of: MoviesResponse.self) { response in
                switch response.result {
                    case .success(let movieResults):
                        completion(.success(movieResults.results))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
}
