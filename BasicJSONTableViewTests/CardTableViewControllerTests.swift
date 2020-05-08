//
//  BasicJSONTableViewTests.swift
//  BasicJSONTableViewTests
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import XCTest
@testable import BasicJSONTableView

class CardTableViewControllerTests: XCTestCase {
    
    func testControllerHasTableView() throws {
        
        let storyboard = try XCTUnwrap(UIStoryboard(name: "Main", bundle: nil))
        let cardTableViewController = try XCTUnwrap(storyboard.instantiateInitialViewController() as? CardTableViewController)
        cardTableViewController.loadViewIfNeeded()
        XCTAssertNotNil(cardTableViewController.tableView)
    }

}
