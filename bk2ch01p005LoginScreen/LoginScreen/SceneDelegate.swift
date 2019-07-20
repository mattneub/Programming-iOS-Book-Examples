

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var which = false // change this to true and relaunch

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            let userHasLoggedIn = which // in real life would be from UserDefaults
            let vc = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(identifier: userHasLoggedIn ?
                    "UserHasLoggedIn" : "LoginScreen")
            window!.rootViewController = vc
            window!.makeKeyAndVisible()
        }
    }

}

