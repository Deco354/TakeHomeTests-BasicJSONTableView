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
    var networking: NetworkController = NetworkController() //Change to use protocol
    var cards: [Card]?
    var cardImages = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networking.requestCards { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cards):
                    self?.cards = cards
                    self?.tableView.reloadData()
                    
                    
                    self?.cardImages = Array.init(repeating: nil, count: cards.count)
                    for (index, card) in cards.enumerated() {
                        self?.networking.downloadImage(from: card.image) { result in
                            self?.cardImages[index] = try? result.get()
                            DispatchQueue.main.async { self?.tableView.reloadData() }
                        }
                    }
                case .failure(let error):
                    print(error)
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

