//
//  CardsViewController.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit
import Foundation

class CardsViewController: UITableViewController {
    var cards: [Card]?

    override func viewDidLoad() {
        super.viewDidLoad()
        requestCards { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cards):
                    self?.cards = cards
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
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

extension CardsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        guard let cards = cards else { return cell }
        
        let card = cards[indexPath.row]
        cell.textLabel?.text = "\(card.value) of \(card.suit)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// Handle request errors later
enum NetworkCallError: Error {
    case noData
    case decodeFailure(error: DecodingError)
}

