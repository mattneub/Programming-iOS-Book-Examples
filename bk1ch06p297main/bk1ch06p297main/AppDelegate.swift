

import UIKit

// look, ma, no @UIApplicationMain!
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // look, ma, no storyboard!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        self.window = self.window ?? UIWindow()
        self.window!.backgroundColor = .white
        self.window!.rootViewController = ViewController()
        self.window!.makeKeyAndVisible()
        return true
    }



}

