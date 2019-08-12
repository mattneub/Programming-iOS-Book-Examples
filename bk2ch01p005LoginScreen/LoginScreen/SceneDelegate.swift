

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var which = false // change this to true and relaunch

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            let userHasLoggedIn = which // in real life would be from UserDefaults
//            let vc = UIStoryboard(name: "Main", bundle: nil)
//                .instantiateViewController(identifier: userHasLoggedIn ?
//                    "UserHasLoggedIn" : "LoginScreen")
            // let's demonstrate a cool new iOS 13 feature
            let vc : UIViewController
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if userHasLoggedIn {
                vc = sb.instantiateViewController(identifier: "UserHasLoggedIn")
            } else {
                vc = sb.instantiateViewController(identifier: "LoginScreen") {
                    let lvc = LoginViewController(coder:$0, message:"You need to log in first.")
                    // could perform further initializations here
                    return lvc
                }
            }
            window!.rootViewController = vc
            window!.makeKeyAndVisible()
        }
    }

}

