//
//  CardStore.swift
//  BasicJSONTableView
//
//  Created by Nick Nguyen on 10/8/20.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

struct Card {
  let code: String
  let image: URL
  let suit: String

  enum CodingKeys: String, CodingKey {
    case code
    case image
    case suit
  }
}


extension Card: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let code = try container.decode(String.self, forKey: .code)
    let imageStringURL = try container.decode(String.self, forKey: .image)
    let suit = try container.decode(String.self, forKey: .suit)

    self.code = code
    self.image = URL(string: imageStringURL)!
    self.suit = suit
  }
}


struct Cards: Decodable {
  let cards: [Card]
}
