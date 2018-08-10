//
//  APIClientTests.swift
//  ToDoTests
//
//  Created by Tomas Sidenfaden on 8/4/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import XCTest
@testable import ToDo

class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Login_UsesExpectedHost() {
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"dasdom",
                      password: "1234",
                      completion: completion)
        XCTAssertEqual(mockURLSession.urlComponents?.host, "awesometodos.com")
    }
    
    func test_Login_UsesExpectedPath() {
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"dasdom",
                      password: "1234",
                      completion: completion)
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    func test_Login_UsesExpectedQuery() {
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName:"dasdöm",
                      password: "%&34",
                      completion: completion)
        XCTAssertEqual(mockURLSession.urlComponents?.percentEncodedQuery,
            "username=dasd%C3%B6m&password=%25%2634")
    }
    
}

extension APIClientTests {
    
    class MockURLSession: SessionProtocol {
        var url: URL?
        var urlComponents: URLComponents?  {
            guard let url = url else { return nil }
            return URLComponents(url: url,
                                 resolvingAgainstBaseURL: true)
        }
        func dataTask(
            with url: URL,
            completionHandler: @escaping
            (Data?, URLResponse?, Error?) -> Void)
            -> URLSessionDataTask {
                self.url = url
                return URLSession.shared.dataTask(with: url)
        }
    }
}


