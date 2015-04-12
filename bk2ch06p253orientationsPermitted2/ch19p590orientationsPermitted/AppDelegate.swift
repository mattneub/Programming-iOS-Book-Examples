

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
        
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        println("supported") // whoa
        
        // uncomment next line to get a different answer...
        // notice that this only works correctly in iOS 8...
        // ... if the _first_ orientation in the Info.plist is _also_ a landscape orientation
        // (rearrange them and you'll see)
        // otherwise, we do a visible launch-and-sudden-rotate (on iPhone only)
        // return Int(UIInterfaceOrientationMask.Landscape.rawValue)
        
        return Int(UIInterfaceOrientationMask.All.rawValue) // still excludes upside-down
    }
    
}

