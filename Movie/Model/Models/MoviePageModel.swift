//
//  MoviePageModel.swift
//  Movie
//
//  Created by admin on 22/10/24.
//

struct MoviePageModel : Codable {
     let page : Int
     let results : [MovieModel]
     let totalPage : Int
     let totalResult : Int
    
    private enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPage = "total_pages"
        case totalResult = "total_results"
    }
}
