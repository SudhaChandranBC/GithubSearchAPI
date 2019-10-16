//
//  GithubSearchAPITests.swift
//  GithubSearchAPITests
//
//  Created by Chandran, Sudha | SDTD on 15/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import GithubSearchAPI

class GithubSearchAPITests: XCTestCase {

    var searchAPI: GithubSearchAPI!
    
    override func setUp() {
        searchAPI = GithubSearchAPI()
    }

    override func tearDown() {
        searchAPI = nil
        super.tearDown()
    }
    
    func testSearchApiSuccess() {
        let promise = expectation(description: "Repositories found!")
        searchAPI.search(matching: "android", filterBy: "rakutentech") { (result) in
            switch result {
            case .success(let repositories):
                XCTAssertNotNil(repositories)
                XCTAssertGreaterThan(repositories.count, 0)
                promise.fulfill()
            case .failure( _):break
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testSearchAPIFailure() {
        let promise = expectation(description: "Repositories not found!")
        searchAPI.search(matching: "", filterBy: "") { (result) in
            switch result {
            case .success( _):break
            case .failure(let err):
                XCTAssertNotNil(err)
                XCTAssertEqual(err, GithubSearchAPI.APIError.decodeError)
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testJSONMapping() throws {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "Repositories", withExtension: "json")!
        let json = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let repo = try decoder.decode(RepositoriesResponse.self, from: json)
        let repositories: [Repository] = repo.items!
        XCTAssertFalse(repositories.isEmpty)
        
        let exampleRepo: Repository = repositories.first!
        XCTAssertEqual(exampleRepo.language, "Java")
        XCTAssertEqual(exampleRepo.description, "Performance Tracking for Android Apps")
        XCTAssertEqual(exampleRepo.name, "android-perftracking")
        XCTAssertFalse(exampleRepo.private)
    }
    
    func testSearchApiForDummyArguments() {
        let promise = expectation(description: "No Repositories found!")
        searchAPI.search(matching: "abcbjbfdbsfhdjsvfdsbfljdslb*#", filterBy: "*****") { (result) in
            switch result {
            case .success(_):break
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, .noData)
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testJSONMappingFromFile() {
        stub(condition: isHost("api.github.com")) { request in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            let error = OHHTTPStubsResponse(error:notConnectedError)
            guard let fixtureFile = OHPathForFile("Repositories.json", type(of: self)) else { return error }
            
            return OHHTTPStubsResponse(
                fileAtPath: fixtureFile,
                statusCode: 200,
                headers: ["Content-Type" : "application/json"]
            )
        }
        
        let promise = expectation(description: "Repositories JSON mapping success")
        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            switch result {
            case .success(let repositories):
                repositories.forEach({ (repository) in
                    print(repository.name!)
                })
                XCTAssertEqual(repositories[0].language, "Java")
                XCTAssertEqual(repositories[0].description, "Performance Tracking for Android Apps")
                XCTAssertEqual(repositories[0].name, "android-perftracking")
                XCTAssertFalse(repositories[0].private)
                promise.fulfill()
            case .failure( _): break
            }
        }
        wait(for: [promise], timeout: 5)
        OHHTTPStubs.removeAllStubs()
    }
    
    func testAPIError() {
        stub(condition: isHost("api.github.com")) { _ in
            let error = NSError(
                domain: "SearchAPI",
                code: 42,
                userInfo: [:]
            )
            return OHHTTPStubsResponse(error: error)
        }
        
        let promise = expectation(description: "SearchAPI Error")
        
        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            switch result {
            case .success( _): break
            case .failure(let err):
                XCTAssertNotNil(err)
                XCTAssertEqual(err, .apiError)
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
        OHHTTPStubs.removeAllStubs()
    }
    
    func testJSONDecodeError() {
        stub(condition: isHost("api.github.com")) { request in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            let error = OHHTTPStubsResponse(error:notConnectedError)
            guard let fixtureFile = OHPathForFile("Error.json", type(of: self)) else { return error }
            
            return OHHTTPStubsResponse(
                fileAtPath: fixtureFile,
                statusCode: 200,
                headers: ["Content-Type" : "application/json"]
            )
        }
        
        let promise = expectation(description: "API decode error")
        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            switch result {
            case .success( _): break
            case .failure(let err):
                XCTAssertNotNil(err)
                XCTAssertEqual(err, .decodeError)
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
        OHHTTPStubs.removeAllStubs()
    }
}
