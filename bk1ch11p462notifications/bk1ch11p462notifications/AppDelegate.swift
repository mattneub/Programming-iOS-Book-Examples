

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]? = [:]) -> Bool {

        NSNotificationCenter.default().addObserver(self,
            selector: #selector(cardTapped),
            name: "cardTapped",
            object: nil)
        
        return true
    }
    
    func cardTapped(_ n:NSNotification) {
        print("card tapped: \(n.object)")
    }
    



}

