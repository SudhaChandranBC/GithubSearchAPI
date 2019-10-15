//
//  GithubSearchAPITests.swift
//  GithubSearchAPITests
//
//  Created by Chandran, Sudha | SDTD on 15/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import XCTest
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
        let promise = expectation(description: "Repositories found!")
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
        let repo = try JSONDecoder().decode(RepositoriesResponse.self, from: json)
        let repositories: [Repository] = repo.items!
        XCTAssertFalse(repositories.isEmpty)
        
        let exampleRepo: Repository = repositories.first!
        XCTAssertEqual(exampleRepo.language, "Java")
        XCTAssertEqual(exampleRepo.description, "Performance Tracking for Android Apps")
        XCTAssertEqual(exampleRepo.name, "android-perftracking")
        XCTAssertFalse(exampleRepo.private)
    }
    
}
