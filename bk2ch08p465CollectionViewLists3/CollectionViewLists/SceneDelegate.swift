

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let scene = scene as! UIWindowScene
        self.window = UIWindow(windowScene: scene)
        self.window!.rootViewController = CollectionViewController()
        // no! absolutely must be in navigation controller, or outlines don't work!!!
        self.window!.rootViewController = UINavigationController(rootViewController: CollectionViewController())
        self.window!.makeKeyAndVisible()
    }

}

