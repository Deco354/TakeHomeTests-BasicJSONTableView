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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCards()
    }
}

extension CardsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        guard let cards = cards else { return cell }
        
        let card = cards[indexPath.row]
        cell.textLabel?.text = "\(card.value) of \(card.suit)"
        cell.imageView?.image = cards[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

private extension CardsViewController {
    func downloadCards() {
        // weak reference is not needed here because neither networking or self have reference to this closure
        networking.requestCards { result in
                switch result {
                case .success(let cards):
                    self.cards = cards
                    self.refreshTable()
                    self.downloadCardImages()
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    private func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func refreshRow(_ row: Int) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
    }
    
    private func downloadCardImages() {
        guard let cards = cards else { return }
        
        for (index, card) in cards.enumerated() {
            // weak self is not needed here because self and the references self holds (networking) hold no reference to this closure
            networking.downloadImage(from: card.imageURL) { result in
                self.cards?[index].image = try? result.get()
                self.refreshRow(index)
            }
        }
    }
}

// Handle request errors later
enum NetworkCallError: Error, Equatable {
    case noData
    case decodeFailure // Handle testable nested error later
    case requestError
}

