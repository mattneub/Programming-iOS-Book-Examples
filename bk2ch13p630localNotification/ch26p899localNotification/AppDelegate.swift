
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        print("start \(#function)")
        NSLog("%@ %@", "\(#function)", "\(launchOptions)")

        if let n = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            delay(0.5) {
                self.doAlert(n)
            }
        }
        
        print("end \(#function)")
        return true
    }
        
    // will get this registration, no matter whether user sees registration dialog or not
    func application(_ application: UIApplication, didRegister settings: UIUserNotificationSettings) {
        print("did register \(settings)")
        // do not change registration here, you'll get a vicious circle
        NotificationCenter.default.post(name: "didRegisterUserNotificationSettings" as Notification.Name, object: self)
    }
    
    func doAlert(_ n:UILocalNotification) {
        print("creating alert")
        let inactive = UIApplication.shared.applicationState == .inactive
        let s = inactive ? "inactive" : "active"
        let alert = UIAlertController(title: "Hey",
            message: "While \(s), I received a local notification: \(n.alertBody)",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.window!.rootViewController!.present(alert,
            animated: true)
    }
    
    // even if user refused to allow alert and sounds etc.,
    // we will receive this call if we are in the foreground when a local notification fires
    func application(_ application: UIApplication, didReceive n: UILocalNotification) {
        print("start \(#function)")
        NSLog("%@", "\(#function)")
        self.doAlert(n)
        print("end \(#function)")
    }
    
    /*
    // new in iOS 8, this is how we will hear about our custom buttons tapped in the alert
    // if user taps our custom action button, id will be its id
    // for background, you can stay in the background and run for a couple of seconds
    // for foreground, you will be brought to foreground
    // but either way, nothing else will be called
    func application(_ application: UIApplication, handleActionWithIdentifier id: String?, forLocalNotification n: UILocalNotification, completionHandler: () -> Void) {
        print("start \(#function)")
        NSLog("%@", "\(#function)")
        print("user tapped \(id)")
        // you _must_ call the completion handler to tell the runtime you did this!
        completionHandler()
        print("end \(#function)")
    }
*/
    
    // new in iOS 9, same as in iOS 8 except that now we have `responseInfo` dictionary coming in
    func application(_ application: UIApplication, handleActionWithIdentifier id: String?, for n: UILocalNotification, withResponseInfo d: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("start \(#function)")
        NSLog("%@", "\(#function)")
        print("user tapped \(id)")
        if let s = d[UIUserNotificationActionResponseTypedTextKey] as? String {
            print(s)
        }
        // you _must_ call the completion handler to tell the runtime you did this!
        completionHandler()
        print("end \(#function)")
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("start \(#function)")
        print("end \(#function)")
    }
}
