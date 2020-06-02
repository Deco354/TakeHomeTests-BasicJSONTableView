//
//  CardsViewController.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class CardsViewController: UITableViewController {
    
    var cards: [Card]?

    override func viewDidLoad() {
        super.viewDidLoad()
        requestCards { [weak self] result in
            switch result {
            case .success(let cards):
                self?.cards = cards
                print(cards)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //move me to another class later
    private func requestCards(completionHandler:@escaping (Result<[Card],NetworkCallError>) -> Void ) {
        
        let session = URLSession.shared
        session.dataTask(with: URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=52")!) { [weak self] data, response, error in
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let deckOfCards = try decoder.decode(Cards.self, from: data)
                completionHandler(.success(deckOfCards.cards))
            } catch {
                
                completionHandler(.failure(.decodeFailure(error: error as! DecodingError)))
            }
        }.resume()
    }
}

// Handle request errors later
enum NetworkCallError: Error {
    case noData
    case decodeFailure(error: DecodingError)
}

