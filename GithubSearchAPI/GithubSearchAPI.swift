//
//  GithubSearchAPI.swift
//  GithubSearchAPI
//
//  Created by Chandran, Sudha | SDTD on 15/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

struct RepositoriesResponse: Decodable {
    let total_count: Int
    let incompleteResults : Bool?
    let items: [Repository]?
}

public struct Repository: Decodable {
    let name: String?
    let `private`: Bool
    let language: String?
    let description: String?
}

struct SearchEndpoint {
    let queryItems: [URLQueryItem]
    let path = "/search/repositories"
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
    
    static func search(matching query: String,
                       filterBy org: String) -> SearchEndpoint {
        return SearchEndpoint(
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "org", value: org)
            ]
        )
    }
}

public class GithubSearchAPI {
    
    private var session: URLSession = .shared
    
    public init() {}

    public enum APIError: Error {
        case apiError
        case invalidEndpoint
        case noData
        case decodeError
    }
    
    public func search(matching query: String,
                filterBy org: String,
                completion: @escaping (Result<[Repository], APIError>) -> ()) {
        
        guard let url = SearchEndpoint.search(matching: query, filterBy: org).url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        session.dataTask(with: url) { (data, _, err) in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(RepositoriesResponse.self, from: data)
                    if let repositories = response.items {
                        repositories.forEach({ (repository) in
                            guard let descr = repository.description else {return}
                            print("->\(descr)")
                        })
                        completion(.success(repositories))
                    } else {
                        completion(.failure(.noData))
                    }
                } catch {
                    completion(.failure(.decodeError))
                }
            } else {
                completion(.failure(.apiError))
                return
            }
        }.resume()
    }
    
}
