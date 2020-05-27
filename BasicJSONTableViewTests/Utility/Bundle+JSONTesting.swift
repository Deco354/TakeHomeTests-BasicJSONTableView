//
//  Bundle+JSONTesting.swift
//  BasicJSONTableViewTests
//
//  Created by Declan McKenna on 27/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

extension Bundle {
    func jsonData(forResource resourceName: String) -> Data {
        guard let url = self.url(forResource: resourceName, withExtension: "json"),
        let data = try? Data(contentsOf: url)
        else {
            fatalError("\(resourceName).json could not be found")
        }
        return data
    }
}
