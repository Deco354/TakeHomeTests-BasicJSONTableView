//
//  NetworkController.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

class NetworkController {
    let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func request(from url: URL, completionHandler: @escaping (Result<CardResponse, NetworkError>) -> Void) {
        session.runDataTask(with: url) { data, response, error in
            
            guard error == nil else { return completionHandler(Result.failure(NetworkError.requestFailure))}
            guard let data = data else { return completionHandler(.failure(.noData)) }
            guard let response = response as? HTTPURLResponse else { return completionHandler(.failure(.invalidResponse))}
            guard (200...299).contains(response.statusCode) else { return completionHandler(.failure(.networkError(code: response.statusCode)))}
        }
    }
}

enum NetworkError: Error, Equatable {
    case noData
    case invalidResponse
    case networkError(code: Int)
    case requestFailure
}
