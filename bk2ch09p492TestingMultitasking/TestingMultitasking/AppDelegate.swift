

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        print(__FUNCTION__)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print(__FUNCTION__)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        print(__FUNCTION__)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        print(__FUNCTION__)
    }

    func applicationWillTerminate(application: UIApplication) {
        print(__FUNCTION__)
    }


}

