

import UIKit

@UIApplicationMain class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow? = MyWindow() // seems this is all we need
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        print("enter")
        print(self.window?.rootViewController)
        defer {
            print("exit") // appears _before_ symbolic breakpoint on `makeKeyAndVisible`
        }
        return true
    }
    
    
}
