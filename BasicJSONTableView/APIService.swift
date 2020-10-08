//
//  APIService.swift
//  BasicJSONTableView
//
//  Created by Nick Nguyen on 10/8/20.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation


class APIService {

  let session: URLSession
  let jsonDecoder = JSONDecoder()
  var cards: Cards?

  lazy var urlRequest: URLRequest = {
    let url = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=12#")!
    return URLRequest(url: url)
  }()

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  func getCardsFromServer(completion: @escaping (Result<[Card],Error>) -> Void) {
    session.dataTask(with: self.urlRequest) { data, response, error in

      guard let data = data else { fatalError("Missing data") }

      guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
        print("Error with the response, unexpected status code: \(String(describing: response))")
        return
      }
      if let err = error {
        completion(.failure(err))
        return
      }
      do {
        let cards = try self.jsonDecoder.decode(Cards.self, from: data)
        self.cards = cards
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }.resume()
  }
}
