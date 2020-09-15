

import UIKit
import os

let logger = Logger(subsystem: "universalLinksTest", category: "link")

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func show(_ url: URL) {
        let alert = UIAlertController(title: "Got one!", message: url.path, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let url = connectionOptions.userActivities.first?.webpageURL {
            logger.log("got universal link on launch: \(url.path)")
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            self.show(url)
        }
    }
}

