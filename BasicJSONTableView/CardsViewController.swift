//
//  ViewController.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

  var apiService: APIService!

  lazy var cardTableView: UITableView = {
    let view = UITableView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.register(UITableViewCell.self, forCellReuseIdentifier: "CardCell")

    return view
  }()

//  func makeDataSource() -> UITableViewDiffableDataSource<Section,Card> {
//
//  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.apiService.getCardsFromServer { (result) in
      let cards = try? result.get()

    }
  }
}

