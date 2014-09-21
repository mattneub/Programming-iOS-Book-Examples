
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
        
        // new in iOS 8! must register to present alert / play sound with a local or push notification
        let types : UIUserNotificationType = .Alert | .Sound
        // if we want custom actions in our alert, we must create them when we register
        let category = UIMutableUserNotificationCategory()
        category.identifier = "coffee" // will need this at notification creation time!
        let action = UIMutableUserNotificationAction()
        action.identifier = "yum"
        action.title = "Yum" // user will see this
        action.destructive = false // the default, I'm just setting it to call attention to its existence
        action.activationMode = .Foreground // if .Background, app just stays in the background! cool
        // if .Background, should also set authenticationRequired to say what to do from lock screen
        
        category.setActions([action], forContext: .Default) // can have 4 for default, 2 for minimal
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(array: [category]))
        application.registerUserNotificationSettings(settings)
        // if this app has never requested this registration,
        // it will put up a dialog asking if we can present alerts etc.
        // when the user accepts or refuses, 
        // will cause us to receive application:didRegisterUserNotificationSettings:
        // can also check at any time with currentUserNotificationSettings
        
        // unfortunately if the user accepts, the default is banner, not alert :(
        
        if let n = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            delay(0.5) {
                self.doAlert(n)
            }
        }
        
        return true
    }
    
    /*
    Also new in iOS 8, in addition to its place in the Notifications Center setttings pane,
    your app automatically gets a preference pane of its own with a Notifications setting
    so user can visit this at any time to change permitted notifications
    ... I did that but it did not cause application:didRegisterUserNotificationSettings to fire
*/
    
    // will get this at launch, no matter whether user sees registration dialog or not
    func application(application: UIApplication, didRegisterUserNotificationSettings settings: UIUserNotificationSettings) {
        println("user has changed notification settings to \(settings)")
    }
    
    func doAlert(n:UILocalNotification) {
        let inactive = UIApplication.sharedApplication().applicationState == .Inactive
        let s = inactive ? "inactive" : "active"
        let alert = UIAlertController(title: "Hey",
            message: "While \(s), I received a location notification: \(n.alertBody)",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.window!.rootViewController.presentViewController(alert,
            animated: true, completion: nil)
    }
    
    // even if user refused to allow alert and sounds etc.,
    // we will receive this call if we are in the foreground when a local notification fires
    func application(application: UIApplication, didReceiveLocalNotification n: UILocalNotification) {
        println("start \(__FUNCTION__)")
        self.doAlert(n)
        println("end \(__FUNCTION__)")
    }
    
    // new in iOS 8, this is how we will hear about our custom buttons tapped in the alert
    // if user taps Open or if this is a banner, id will be nil
    // if user taps our custom action button, id will be its id
    func application(application: UIApplication, handleActionWithIdentifier id: String?, forLocalNotification n: UILocalNotification, completionHandler: () -> Void) {
        println("start \(__FUNCTION__)")
        println("user tapped \(id)")
        self.doAlert(n)
        // you _must_ call the completion handler to tell the runtime you did this!
        completionHandler()
        println("end \(__FUNCTION__)")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
    }
}
