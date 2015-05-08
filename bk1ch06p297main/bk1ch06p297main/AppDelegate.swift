

import UIKit

// look, ma, no @UIApplicationMain!
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // look, ma, no storyboard!
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.rootViewController =
            MyViewController(nibName:"MyViewController", bundle:nil)
        self.window!.makeKeyAndVisible()
        return true
    }



}

