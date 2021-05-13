

import UIKit
import os

@available(iOS 14.0, *)
let logger = Logger(subsystem: "universalLinksTest", category: "link")

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

@available(iOS 14.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func show(_ url: URL) {
        let alert = UIAlertController(title: "Got one!", message: url.path, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        logger.log("launching")
        if let url = connectionOptions.userActivities.first?.webpageURL {
            logger.log("got universal link on launch: \(url.path)")
            delay(2) {
                self.show(url)
            }
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            logger.log("continuing")
            self.show(url)
        }
    }
}

