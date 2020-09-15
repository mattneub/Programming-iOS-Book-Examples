

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var timer : Timer?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // to test, background the app, watch until the app is suspended, count 10 seconds, bring to foreground again

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("backgrounding the app, starting timers for 60 seconds", Date())
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            print("deadline 60 seconds ended", Date())
        }
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 60) {
            print("wallDeadline 60 seconds ended", Date())
        }
        self.timer = Timer(timeInterval: 1, repeats: true) { _ in
            print("I'm still awake!")
        }
        self.timer?.fire()

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("app coming to front", Date())
        self.timer?.invalidate()
    }



}

