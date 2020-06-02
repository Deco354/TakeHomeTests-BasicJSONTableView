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
    var cardImages = [UIImage?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestCards { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cards):
                    self?.cards = cards
                    self?.cardImages = Array.init(repeating: nil, count: cards.count)
                    self?.tableView.reloadData()
                    self?.downloadImages(from: cards.map{ $0.image })
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //move me to another class later
    private func requestCards(completionHandler:@escaping (Result<[Card],NetworkCallError>) -> Void ) {
        
        let session = URLSession.shared
        session.dataTask(with: URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=52")!) { data, response, error in
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
    
    //Todo: Handle errors
    private func downloadImages(from urls: [URL]) {
        DispatchQueue.global().async { [weak self] in
            for (index, imageURL) in urls.enumerated() {
                if let data = try? Data(contentsOf: imageURL),
                    let image = UIImage(data: data) {
                    self?.cardImages[index] = image
                    DispatchQueue.main.async {
                        self?.tableView.reloadData() //Find way to do this without reloading entire table each time
                    }
                }
            }
        }
    }
}

extension CardsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        guard let cards = cards else { return cell }
        
        let card = cards[indexPath.row]
        cell.textLabel?.text = "\(card.value) of \(card.suit)"
        cell.imageView?.image = cardImages[indexPath.row]
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

