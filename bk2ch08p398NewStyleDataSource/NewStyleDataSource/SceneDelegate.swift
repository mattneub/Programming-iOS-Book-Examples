
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            print("here")
            self.window = UIWindow(windowScene: windowScene)
            self.window!.rootViewController = UINavigationController(rootViewController:RootViewController())
            self.window!.backgroundColor = .white
            self.window!.makeKeyAndVisible()
        }
    }


}

