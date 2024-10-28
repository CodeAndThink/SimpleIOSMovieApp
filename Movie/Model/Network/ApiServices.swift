//
//  ApiServices.swift
//  Movie
//
//  Created by admin on 22/10/24.
//
import Foundation
import Alamofire

class ApiServices {
    private let baseUrl : String = "https://api.themoviedb.org/3/"
    private let accessToken : String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlOWMxZDBiYmUxMGZlZTIzZWNhYjRkYThiMGU5NzFkMyIsIm5iZiI6MTcyOTU3ODk4Ny44ODUzNDUsInN1YiI6IjY2ODE0MzU4NWNkMDlkN2ExMjQ3ZGE2OSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SJZfreRu5WYSMdiVuiimYeHF-M3ECT6UYmEEr28lRkA"
    private static var sharedApiService : ApiServices = {
        let apiService = ApiServices()
        return apiService
    }()
    
    private init() {}
    
    class func shared() -> ApiServices {
        return sharedApiService
    }
        
    func fetchData<T: Decodable>(endPoint: String, queryParameters: [String: String]? = nil) async throws -> T {
        let urlString = baseUrl + endPoint
        
        var parameters: Parameters? = nil
        if let queryParameters = queryParameters {
            parameters = queryParameters
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(urlString, parameters: parameters, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let dataPage):
                        continuation.resume(returning: dataPage)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    //    func fetchData (endPoint : String, queryParameters : [String : String]? = nil) async throws -> MoviePageModel {
    //
    //        guard var urlComponents = URLComponents(string: baseUrl + endPoint) else {
    //            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    //        }
    //
    //        if let queryParameters = queryParameters {
    //            urlComponents.queryItems = queryParameters.map{URLQueryItem(name: $0.key, value: $0.value)}
    //        }
    //
    //        guard let url = urlComponents.url else {
    //            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //        request.addValue("Bearer: \(accessToken)", forHTTPHeaderField: "Authorization")
    //        request.addValue("accept", forHTTPHeaderField: "application/json")
    //
    //        let (data, response) = try await URLSession.shared.data(for: request)
    //
    //        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    //            throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey : "Invalid Response"])
    //        }
    //
    //        do {
    //            let dataPage = try JSONDecoder().decode(MoviePageModel.self, from: data)
    //            return dataPage
    //        } catch {
    //            throw error
    //        }
    //    }
}
