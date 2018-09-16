

import UIKit

@UIApplicationMain class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow? = MyWindow() // seems this is all we need
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        print("enter")
        print(self.window?.rootViewController as Any)
        defer {
            print("exit") // appears _before_ symbolic breakpoint on `makeKeyAndVisible`
        }
        // experiment: if we call makeKeyAndVisible, is it called twice? NO!
        // self.window!.makeKeyAndVisible()
        return true
    }
    
    
}
