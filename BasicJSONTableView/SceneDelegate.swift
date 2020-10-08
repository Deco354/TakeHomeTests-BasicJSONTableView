//
//  SceneDelegate.swift
//  BasicJSONTableView
//
//  Created by Declan McKenna on 08/05/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let rootVC = window?.rootViewController as? CardsViewController {
            rootVC.apiService = APIService()
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

