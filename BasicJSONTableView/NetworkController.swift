//
//  NetworkController.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 03/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    let session: URLSession
    
    init(with session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func requestCards(completionHandler:@escaping (Result<[Card],NetworkCallError>) -> Void ) {
        session.dataTask(with: URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=52")!) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let deckOfCards = try decoder.decode(Cards.self, from: data)
                completionHandler(.success(deckOfCards.cards))
            } catch {
                completionHandler(.failure(.decodeFailure))
            }
        }.resume()
    }
    
    //Todo: Handle errors
    func downloadImage(from url: URL, completionHandler: @escaping (Result<UIImage, NetworkCallError>) -> Void) {
        DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    completionHandler(.success(image))
                }
            }
    }
}
