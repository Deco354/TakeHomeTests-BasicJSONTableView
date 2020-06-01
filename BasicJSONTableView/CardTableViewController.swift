//
//  CardTableViewController.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {
    
    let networkController = NetworkController()
    var cards = [Card]()
    
    override func viewDidLoad() {
        networkController.request(from: URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=52")!) { [weak self] result in
            switch result {
            case .success(let cards):
                self?.cards = cards
                DispatchQueue.main.async {
                    self?.tableView.reloadData()                    
                }
            case .failure(let error):
                print("Request Failed with error: \(error)")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CardCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)
        cell.textLabel?.text = cards[indexPath.row].value
        return cell
    }
}
