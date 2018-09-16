

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {

        NotificationCenter.default.addObserver(self,
            selector: #selector(cardTapped),
            name: .cardTapped,
            object: nil)
        
        return true
    }
    
    @objc func cardTapped(_ n:Notification) {
        print("card tapped: \(n.object ?? "nil")")
    }
    



}

