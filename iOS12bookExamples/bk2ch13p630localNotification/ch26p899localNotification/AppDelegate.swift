
import UIKit
import UserNotifications

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    let notifHelper = MyUserNotificationHelper()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // must set user notification center delegate before we finish launching!
        let center = UNUserNotificationCenter.current()
        center.delegate = self.notifHelper
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("start \(#function)")
        print("end \(#function)")
    }
    
    // cute feature, but it's a pity we can't prevent ourselves from being activated
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "coffee.schedule" {
            if let d = shortcutItem.userInfo {
                if let time = d["time"] as? Int {
                    // for debugging purposes, let's show an actual alert
                    let alert = UIAlertController(title: "Coffee!", message: "Coffee reminder scheduled in \(time) minutes", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.window!.rootViewController?.present(alert, animated: true)
                    completionHandler(true)
                }
            }
        }
        completionHandler(false) // really not sure what the point is
    }

}

