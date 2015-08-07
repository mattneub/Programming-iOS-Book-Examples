

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        print("supported") // whoa
        
        // uncomment next line to get a different answer...
        // NB in my tests this works even if portrait is first in the Info.plist in iOS 9!
        // However, order still matters; if user is holding at the other landscape orientation...
        // we launch upside down and then rotate
        // moreover, behind the scenes there is an extra rotation regardless in iOS 9
        // (we are back to launching always into portrait if we can, even if the user doesn't see it)
        // return .Landscape
        
        // launch into portrait, then rotate if user is holding in landscape
        return .All // still excludes upside-down
    }
    
}

