//
//  CardTests.swift
//  BasicJSONTableViewTests
//
//  Created by Declan McKenna on 12/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import XCTest
@testable import BasicJSONTableView

class CardTests: XCTestCase {
    let decoder = JSONDecoder()
    
    func testDecodeValidJSON() {
        let expectedCards = [Card(image: "https://deckofcardsapi.com/static/img/5H.png", value: "5"), Card(image: "https://deckofcardsapi.com/static/img/3C.png", value: "3")]
        
        let validJSON = jsonData(forResource: "Card")
        do {
            let decodedCards = try decoder.decode(CardResponse.self, from: validJSON).cards
            XCTAssertEqual(decodedCards, expectedCards)
        } catch(let error) {
            XCTFail("JSON Parsing failed with error: \(error)")
        }
    }

}

private extension CardTests {
    func jsonData(forResource resourceName: String) -> Data {
        let bundle = Bundle(for: Self.self)
        guard let url = bundle.url(forResource: resourceName, withExtension: "json"),
        let data = try? Data(contentsOf: url)
        else {
            fatalError("\(resourceName).json could not be found")
        }
        return data
    }
}
