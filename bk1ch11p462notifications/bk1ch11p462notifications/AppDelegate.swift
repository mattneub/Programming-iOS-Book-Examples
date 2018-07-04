

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {

        NotificationCenter.default.addObserver(self,
            selector: #selector(cardTapped),
            name: Card.tappedNotification,
            object: nil)
        
        return true
    }
    
    @objc func cardTapped(_ n:Notification) {
        print("card tapped: \(n.object ?? "nil")")
    }
    



}

