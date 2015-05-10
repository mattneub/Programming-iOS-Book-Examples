

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "cardTapped:",
            name: "cardTapped",
            object: nil)
        
        return true
    }
    
    func cardTapped(n:NSNotification) {
        println("card tapped: \(n.object)")
    }
    



}

