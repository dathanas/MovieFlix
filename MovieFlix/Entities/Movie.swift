//
//  Movie.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 8/3/24.
//

import Foundation

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int 
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let runtime: Int?
    let overview: String?
    let homepage: String?
    var isFavorite: Bool = false
    let genres: [Genre]?
    let credits: Credits?
    let reviews: Reviews?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case runtime
        case overview
        case homepage
        case genres
        case credits
        case reviews
    }
}


struct Genre: Decodable {
    let id: Int
    let name: String
}

struct Credits: Decodable {
    let cast: [CastMember]?
}

struct CastMember: Decodable {
    let id: Int?
    let name: String?
    let knownForDepartment: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case knownForDepartment = "known_for_department"
    }
}

struct Reviews: Decodable {
    let results: [Review]?
}

struct Review: Decodable {
    let author: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case content
    }
}
