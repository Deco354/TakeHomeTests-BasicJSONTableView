//
//  NetworkSession.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

protocol NetworkSession {
    func runDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func runDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
