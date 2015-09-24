
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("start \(__FUNCTION__)")
        NSLog("%@ %@", "\(__FUNCTION__)", "\(launchOptions)")

        if let n = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            delay(0.5) {
                self.doAlert(n)
            }
        }
        
        print("end \(__FUNCTION__)")
        return true
    }
        
    // will get this registration, no matter whether user sees registration dialog or not
    func application(application: UIApplication, didRegisterUserNotificationSettings settings: UIUserNotificationSettings) {
        print("did register \(settings)")
        // do not change registration here, you'll get a vicious circle
        NSNotificationCenter.defaultCenter().postNotificationName("didRegisterUserNotificationSettings", object: self)
    }
    
    func doAlert(n:UILocalNotification) {
        print("creating alert")
        let inactive = UIApplication.sharedApplication().applicationState == .Inactive
        let s = inactive ? "inactive" : "active"
        let alert = UIAlertController(title: "Hey",
            message: "While \(s), I received a local notification: \(n.alertBody)",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.window!.rootViewController!.presentViewController(alert,
            animated: true, completion: nil)
    }
    
    // even if user refused to allow alert and sounds etc.,
    // we will receive this call if we are in the foreground when a local notification fires
    func application(application: UIApplication, didReceiveLocalNotification n: UILocalNotification) {
        print("start \(__FUNCTION__)")
        NSLog("%@", "\(__FUNCTION__)")
        self.doAlert(n)
        print("end \(__FUNCTION__)")
    }
    
    /*
    // new in iOS 8, this is how we will hear about our custom buttons tapped in the alert
    // if user taps our custom action button, id will be its id
    // for background, you can stay in the background and run for a couple of seconds
    // for foreground, you will be brought to foreground
    // but either way, nothing else will be called
    func application(application: UIApplication, handleActionWithIdentifier id: String?, forLocalNotification n: UILocalNotification, completionHandler: () -> Void) {
        print("start \(__FUNCTION__)")
        NSLog("%@", "\(__FUNCTION__)")
        print("user tapped \(id)")
        // you _must_ call the completion handler to tell the runtime you did this!
        completionHandler()
        print("end \(__FUNCTION__)")
    }
*/
    
    // new in iOS 9, same as in iOS 8 except that now we have `responseInfo` dictionary coming in
    func application(application: UIApplication, handleActionWithIdentifier id: String?, forLocalNotification n: UILocalNotification, withResponseInfo d: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("start \(__FUNCTION__)")
        NSLog("%@", "\(__FUNCTION__)")
        print("user tapped \(id)")
        if let s = d[UIUserNotificationActionResponseTypedTextKey] as? String {
            print(s)
        }
        // you _must_ call the completion handler to tell the runtime you did this!
        completionHandler()
        print("end \(__FUNCTION__)")
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("start \(__FUNCTION__)")
        print("end \(__FUNCTION__)")
    }
}
