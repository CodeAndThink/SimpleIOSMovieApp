//
//  MovieGenre.swift
//  Movie
//
//  Created by admin on 24/10/24.
//

struct MovieGenre : Codable {
    let id : Int
    let genreName : String
    
    private enum CodingKeys : String, CodingKey {
        case id
        case genreName = "name"
    }
}
