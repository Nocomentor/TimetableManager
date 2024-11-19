//
//  SceneDelegate.swift
//  TimetableManager
//
//  Created by Krzysztof on 19/11/2024.
//

import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func sceneDidDisconnect(_ scene: UIScene) {
        print("scene stop")
        LiveActivityManager.shared.stopActivity()
    }

}
