//
//  Card.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 02/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

struct Cards: Decodable {
    let cards: [Card]
}

struct Card: Decodable {
    let imageURL: URL
    let value: String
    let suit: String
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case value, suit
    }
}
