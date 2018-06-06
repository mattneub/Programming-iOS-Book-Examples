

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        print("supported") // whoa, call me 7 times why don't you
        
        // okay, all my comments in what follows are made wrong by iOS 11
        // in iOS 11 we just launch straight into however the user is holding the device
        
        // uncomment next line to get a different answer...
        // NB in my tests this works even if portrait is first in the Info.plist in iOS 9!
        // However, order still matters; if user is holding at the other landscape orientation...
        // we launch upside down and then rotate
        // moreover, behind the scenes there is an extra rotation regardless in iOS 9
        // (we are back to launching always into portrait if we can, even if the user doesn't see it)
        // return .landscape
        
        // launch into portrait, then rotate if user is holding in landscape
        return .all // still excludes upside-down
    }
    
}

