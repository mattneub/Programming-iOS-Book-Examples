

import UIKit

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

