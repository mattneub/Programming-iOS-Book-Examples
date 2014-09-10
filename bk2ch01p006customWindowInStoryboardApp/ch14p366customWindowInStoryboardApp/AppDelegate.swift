

import UIKit

@UIApplicationMain class AppDelegate : UIResponder, UIApplicationDelegate {
    
    lazy var window : UIWindow = {
        return MyWindow(frame: UIScreen.mainScreen().bounds)
    }()
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        return true
    }
    
    
}