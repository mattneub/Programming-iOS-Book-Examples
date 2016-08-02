

import UIKit

// look, ma, no @UIApplicationMain!
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // look, ma, no storyboard!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.window = UIWindow()
        self.window!.backgroundColor = UIColor.red
        self.window!.rootViewController = // UIViewController()
            MyViewController(nibName:"MyViewController", bundle:nil)
        self.window!.makeKeyAndVisible()
        return true
    }



}

