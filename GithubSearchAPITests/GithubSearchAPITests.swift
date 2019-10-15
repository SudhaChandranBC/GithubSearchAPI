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

    func testAdd() {
        XCTAssertEqual(searchAPI.add(a: 1, b: 1), 2)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
