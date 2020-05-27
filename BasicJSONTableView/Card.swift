//
//  Card.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 12/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

    // MARK: - CardResponse
    struct CardResponse: Decodable, Equatable {
        let cards: [Card]
        
        enum CodingKeys: String, CodingKey {
            case cards
        }
        
        // MARK: - Card
        struct Card: Decodable, Equatable {
            let image: String
            let value: String
        }
    }
