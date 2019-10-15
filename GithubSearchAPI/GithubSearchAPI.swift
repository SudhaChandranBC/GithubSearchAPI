//
//  GithubSearchAPI.swift
//  GithubSearchAPI
//
//  Created by Chandran, Sudha | SDTD on 15/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

// MARK: Search API result Model
struct RepositoriesResponse: Decodable {
    let total_count: Int
    let incompleteResults : Bool?
    ///Array of Github Repositories
    let items: [Repository]?
}

// MARK: Github Repository Model
public struct Repository: Decodable {
    let name: String?
    let `private`: Bool
    let language: String?
    let description: String?
}

// MARK: Search Endpoint Model
struct SearchEndpoint {
    ///Search options to ber specified in an array of query items for the URL in the order in which they appear in the original query string.
    let queryItems: [URLQueryItem]
    
    ///The path subcomponent for Github Search API
    let path = "/search/repositories"
    
    /**
     
     Returns url required to fetch repositories.
     Example Query: [https://api.github.com/search/repositories?q=android+org:rakutentech ](https://api.github.com/search/repositories?q=android+org:rakutentech)
     
     */
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
    
    /**
     Creates an endpoint for search with a query or organization
     
     - parameter query: The string for finding repository.
     - parameter org: The organization that owns the repositories.
     - Returns: An instance of endpoint by adding search options into the querystring of the url.

     */
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
    
    /**
     Search API errors
     
     - apiError:        Error returned by api.
     - invalidEndpoint: Error returned when enpoint is wrong
     - noData:          Error returned when there is no data
     - decodeError:     Error returned when decosing of json fails
     */
    public enum APIError: Error {
        case apiError
        case invalidEndpoint
        case noData
        case decodeError
    }
    
    /**
     Fetches repositories for a query or organization
     
     - parameter query: The string for finding repository.
     - parameter org: The organization that owns the repositories.
     - parameter completion: Callback for the outcome of the fetch.
     - Returns: A Result type value that represents either a success or a failure, including an associated value in each case which is 1. Array of repositories and 2. An APIError instance.

     */
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
                        completion(.success(repositories)) //Successfully fetch repositories
                    } else { //Fails when there are no repositories
                        completion(.failure(.noData))
                    }
                } catch { //JSON decode fails
                    completion(.failure(.decodeError))
                }
            } else { //API returns an error
                completion(.failure(.apiError))
                return
            }
            }.resume()
    }
    
}
