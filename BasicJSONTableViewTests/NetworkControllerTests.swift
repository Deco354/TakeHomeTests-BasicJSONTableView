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

    func testSuccessfulRequest() {
        let jsonData = Bundle(for: Self.self).jsonData(forResource: "Card")
        let stubURLSession = MockURLSession(data: jsonData, response: HTTPURLResponse(statusCode: 200), error: nil)
        let networkController = NetworkController(session: stubURLSession)
        networkController.request(from: stubURL) { result in
            XCTAssertNotNil(try? result.get())
        }
    }
    
    func testDatalessRequest() {
        let networkController = NetworkController(session: MockURLSession(data: nil, response: HTTPURLResponse(statusCode: 200), error: nil))
        networkController.request(from: stubURL) {result in
            guard case let .failure(error) = result, case .noData = error else {
                return XCTFail()
            }
        }
    }
    
    func testFailedRequest() {
        let networkController = NetworkController(session: MockURLSession(data: nil, response: nil, error: testError))
        networkController.request(from: stubURL) { result in
            XCTAssertEqual(result, Result.failure(NetworkError.requestFailure(error: self.testError)))
        }
    }

    func testNetworkError() {
        let networkController = NetworkController(session: MockURLSession(data: Data(), response: HTTPURLResponse(statusCode: 102), error: nil))
        networkController.request(from: stubURL) { result in
            XCTAssertEqual(result, Result.failure(NetworkError.networkError(code: 102)))
        }
    }
}

private extension NetworkControllerTests {
    var stubURL: URL { URL(fileURLWithPath: "test.com") }
    var nonHTTPResponse: URLResponse { URLResponse() }
    var testError: NSError { NSError(domain: "", code: 0) }
}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(fileURLWithPath: "test.com"), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch(lhs,rhs) {
        case let (.networkError(lhsErrorCode),.networkError(rhsErrorCode)):
            return lhsErrorCode == rhsErrorCode
        case let(.requestFailure(lhsError),.requestFailure(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return lhs.self == rhs.self
        }
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
