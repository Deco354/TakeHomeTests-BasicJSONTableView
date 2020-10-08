//
//  ViewController.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit
import SDWebImage

class CardsViewController: UIViewController {

    var apiService: APIService!
    private let cellReuseIdentifier = "cell"

    lazy var cardTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.dataSource = self
        view.rowHeight = 200
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiService.getCardsFromServer { (result) in
            let _ = try? result.get()
            DispatchQueue.main.async {
                self.cardTableView.reloadData()
            }
        }

        view.addSubview(cardTableView)

        NSLayoutConstraint.activate([
            cardTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardTableView.topAnchor.constraint(equalTo: view.topAnchor),
            cardTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }
}


extension CardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiService.cards?.cards.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        if cell == nil || cell?.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        }
        let card = apiService.cards?.cards[indexPath.row]
        cell.textLabel?.text = card?.code
        cell.detailTextLabel?.text = card?.suit
        cell.imageView?.sd_setImage(with: card?.image,
                                     placeholderImage: nil,
                                     options: SDWebImageOptions.highPriority,
                                     context: nil,
                                     progress: nil,
                                     completed: { (downloadedImage, downloadedError, cacheType, downloadURL) in

                                        cell?.setNeedsUpdateConstraints()

                                        if let error = downloadedError {
                                            print(error.localizedDescription)
                                        } else {
                                            print("Success: \(downloadURL?.absoluteString ?? "SUCCESS")")

                                        }
                                     })
        return cell
    }
}
