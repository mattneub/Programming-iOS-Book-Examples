

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // use NSLog so we can read from the device console
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NSLog("%@", __FUNCTION__)
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        NSLog("%@", __FUNCTION__)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        NSLog("%@", __FUNCTION__)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        NSLog("%@", __FUNCTION__)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        NSLog("%@", __FUNCTION__)
    }

    func applicationWillTerminate(application: UIApplication) {
        NSLog("%@", __FUNCTION__)
    }


}

