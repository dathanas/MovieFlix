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
    
    private let apiKey: String = ProcessInfo.processInfo.environment["API_KEY"]!
    
    func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page)"
        AF.request(urlString)
            .responseDecodable(of: MoviesResponse.self) { response in
                switch response.result {
                    case .success(let moviesResponse):
                        completion(.success(moviesResponse.results))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
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
        
        AF.request(urlString, parameters: parameters)
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

