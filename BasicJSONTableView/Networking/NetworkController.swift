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
    
    func request(from url: URL, completionHandler: @escaping (Result<[Card], NetworkError>) -> Void) {
        session.runDataTask(with: url) { data, response, error in
            
            guard error == nil else { return completionHandler(Result.failure(NetworkError.requestFailure))}
            guard let data = data else { return completionHandler(.failure(NetworkError.noData)) }
            guard let response = response as? HTTPURLResponse else { return completionHandler(.failure(NetworkError.invalidResponse))}
            guard (200...299).contains(response.statusCode) else { return completionHandler(.failure(NetworkError.networkError(code: response.statusCode)))}
            
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(CardResponse.self, from: data)
                completionHandler(.success(decodedResponse.cards))
            } catch {
                completionHandler(.failure(NetworkError.decodingError))
            }
        }
    }
}

enum NetworkError: Error, Equatable {
    case noData
    case invalidResponse
    case networkError(code: Int)
    case requestFailure
    case decodingError
}
