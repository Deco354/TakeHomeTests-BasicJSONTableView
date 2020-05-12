//
//  NetworkControllerTests.swift
//  BasicJSONTableViewTests
//
//  Created by Declan McKenna on 11/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import XCTest
@testable import BasicJSONTableView

class NetworkControllerTests: XCTestCase {

    func testDatalessRequest() {
        let networkController = NetworkController(session: MockURLSession(data: nil, response: HTTPURLResponse(statusCode: 200), error: nil))
        networkController.request(from: stubURL) {result in
            XCTAssertEqual(result, Result.failure(.noData))
        }
    }
    
    func testFailedRequest() {
        let networkController = NetworkController(session: MockURLSession(data: nil, response: nil, error: NSError()))
        networkController.request(from: stubURL) { result in
            XCTAssertEqual(result, Result.failure(.requestFailure))
        }
    }
  
    func testNetworkError() {
        let networkController = NetworkController(session: MockURLSession(data: Data(), response: HTTPURLResponse(statusCode: 102), error: nil))
        networkController.request(from: stubURL) { result in
            XCTAssertEqual(result, Result.failure(.networkError(code: 102)))
        }
    }
}

private extension NetworkControllerTests {
    var stubURL: URL { URL(fileURLWithPath: "test.com") }
    var nonHTTPResponse: URLResponse { URLResponse() }
//    var failedResponse: HTTPURLResponse { HTTPURLResponse(}
}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(fileURLWithPath: "test.com"), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

private extension NetworkControllerTests {
    class MockURLSession: NetworkSession {
        
        let data: Data?
        var response: URLResponse?
        let error: Error?

        init(data: Data?, response: URLResponse?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        func runDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            completionHandler(data, response, error)
        }
    }
}

extension Card: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return true
    }
}
