

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var progress : Double = 0.0 {
        didSet {
            print("progress set to \(progress)")
        }
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doProg:", name: "prog", object: self)
        NSNotificationCenter.defaultCenter().postNotificationName("prog", object: self, userInfo: ["progress":4.2])
        return true
    }
    
    func doProg(n:NSNotification) {
        if let prog = n.userInfo?["progress"] as? Double {
            self.progress = prog
        }
    }



}

