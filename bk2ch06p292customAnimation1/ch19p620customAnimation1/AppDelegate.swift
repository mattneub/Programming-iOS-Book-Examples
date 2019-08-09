

import UIKit

class FirstViewController : UIViewController {}

class SecondViewController : UIViewController {}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var animator : Animator?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        if let tbc = self.window?.rootViewController as? UITabBarController {
            self.animator = Animator(tabBarController: tbc)
            tbc.delegate = self.animator
        }
        return true
    }
}

extension AppDelegate {
    @objc func buttonTap(_ sender: Any) {
        print("tap!") // testing whether user can interact during animation
        // nope, looks like everything is okay
    }
}

