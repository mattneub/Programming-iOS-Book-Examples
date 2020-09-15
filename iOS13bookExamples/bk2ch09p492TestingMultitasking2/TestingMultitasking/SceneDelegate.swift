//
//  SceneDelegate.swift
//  SplitTest
//
//  Created by Matt Neuburg on 9/8/19.
//  Copyright © 2019 Matt Neuburg. All rights reserved.
//

import UIKit
import os.log


class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        os_log("%{public}@ %{public}@", log: log, self, #function)
        return; // comment out to test interleaving of events
        if let ws = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: ws)
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VC")
            self.window?.makeKeyAndVisible()
            os_log("%{public}@ %{public}@", log: log, self, #function)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        os_log("%{public}@ %{public}@", log: log, self, #function)

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        os_log("%{public}@ %{public}@", log: log, self, #function)

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        os_log("%{public}@ %{public}@", log: log, self, #function)

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        os_log("%{public}@ %{public}@", log: log, self, #function)

    }


}

