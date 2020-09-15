

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
        self.window = self.window ?? UIWindow()
        // work around margin layout bug
        self.window!.rootViewController = UINavigationController(rootViewController:RootViewController())
        // self.window!.rootViewController = RootViewController()
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
    }
}
