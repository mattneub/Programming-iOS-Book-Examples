

import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            let rvc = RootViewController(nibName: "MyNib", bundle: nil)
            // let rvc = RootViewController() // *
            self.window!.rootViewController = rvc // *
            self.window!.backgroundColor = .white
            self.window!.makeKeyAndVisible()
        }
    }
}
