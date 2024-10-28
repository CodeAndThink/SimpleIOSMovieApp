//
//  Repository.swift
//  Movie
//
//  Created by admin on 22/10/24.
//

import Foundation

class Repository {
    private var apiService : ApiServices
    private let apiKey = "e9c1d0bbe10fee23ecab4da8b0e971d3"
    private static var sharedRepository : Repository = {
        let apiService = ApiServices.shared()
        let repository = Repository(apiService: apiService)
        return repository
    }()
    
    private init(apiService: ApiServices) {
        self.apiService = apiService
    }
    
    class func shared() -> Repository{
        return sharedRepository
    }
    
    func fetchPopularMovieData (page : Int) async throws -> [MovieModel] {
        let dataPage : MoviePageModel = try await apiService.fetchData(endPoint: "movie/popular", queryParameters: ["api_key" : apiKey, "lang" : "en-US", "page" : String(page)])
        return dataPage.results
    }
    
    func fetchDetailMovieData (movieId : Int) async throws -> MovieModel {
        let data : MovieModel = try await apiService.fetchData(endPoint: "movie/\(movieId)", queryParameters: ["api_key" : apiKey, "lang" : "en-US"])
        return data
    }
}
