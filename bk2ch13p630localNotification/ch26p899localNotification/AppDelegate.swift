
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
        println("start \(__FUNCTION__)")

        NSLog("%@ %@", "\(__FUNCTION__)", "\(launchOptions)")

        if let n = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            delay(0.5) {
                self.doAlert(n)
            }
        }
        
        self.registerMyNotification(application)
        
        println("end \(__FUNCTION__)")
        return true
    }
    
    /*
    Also new in iOS 8, in addition to its place in the Notifications Center setttings pane,
    your app automatically gets a preference pane of its own with a Notifications setting
    so user can visit this at any time to change permitted notifications
    ... I did that but it did not cause application:didRegisterUserNotificationSettings to fire
*/
    
    
    func registerMyNotification(application:UIApplication) {
        // new in iOS 8! must register to present alert / play sound with a local or push notification
        let types : UIUserNotificationType = .Alert | .Sound
        // if we want custom actions in our alert, we must create them when we register
        let category = UIMutableUserNotificationCategory()
        category.identifier = "coffee" // will need this at notification creation time!
        let action1 = UIMutableUserNotificationAction()
        action1.identifier = "yum"
        action1.title = "Yum" // user will see this
        action1.destructive = false // the default, I'm just setting it to call attention to its existence
        action1.activationMode = .Foreground // if .Background, app just stays in the background! cool
        // if .Background, should also set authenticationRequired to say what to do from lock screen
        
        let action2 = UIMutableUserNotificationAction()
        action2.identifier = "ohno"
        action2.title = "Oh, No!" // user will see this
        action2.destructive = false // the default, I'm just setting it to call attention to its existence
        action2.activationMode = .Background // if .Background, app just stays in the background! cool
        // if .Background, should also set authenticationRequired to say what to do from lock screen
        
        category.setActions([action1, action2], forContext: .Default) // can have 4 for default, 2 for minimal
        let settings = UIUserNotificationSettings(forTypes: types, categories: Set([category]))
        application.registerUserNotificationSettings(settings)
        // if this app has never requested this registration,
        // it will put up a dialog asking if we can present alerts etc.
        // when the user accepts or refuses,
        // will cause us to receive application:didRegisterUserNotificationSettings:
        // can also check at any time with currentUserNotificationSettings
        
        // unfortunately if the user accepts, the default is banner, not alert :(
    }
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        println("start \(__FUNCTION__)")
        
        // I think this should go here, so that we re-register every time we come to the foreground...
        // scenario: we register, user sees dialog, user refuses
        // later, user accepts in Settings
        // but if we now try to present notification, we can't because our registration didn't go through the first time
        // this way, we are always registering so that if we are ever accepted, we can do it
        self.registerMyNotification(application)
        
        println("end \(__FUNCTION__)")


    }
    
    // will get this registration, no matter whether user sees registration dialog or not
    func application(application: UIApplication, didRegisterUserNotificationSettings settings: UIUserNotificationSettings) {
        println("did register \(settings)")
        // do not change registration here, you'll get a vicious circle
    }
    
    func doAlert(n:UILocalNotification) {
        println("creating alert")
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
        println("start \(__FUNCTION__)")
        NSLog("%@", "\(__FUNCTION__)")
        self.doAlert(n)
        println("end \(__FUNCTION__)")
    }
    
    // new in iOS 8, this is how we will hear about our custom buttons tapped in the alert
    // if user taps our custom action button, id will be its id
    // for background, you can stay in the background and run for a couple of seconds
    // for foreground, you will be brought to foreground
    // but either way, nothing else will be called
    func application(application: UIApplication, handleActionWithIdentifier id: String?, forLocalNotification n: UILocalNotification, completionHandler: () -> Void) {
        println("start \(__FUNCTION__)")
        NSLog("%@", "\(__FUNCTION__)")
        println("user tapped \(id)")
        // you _must_ call the completion handler to tell the runtime you did this!
        completionHandler()
        println("end \(__FUNCTION__)")
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
    }
}
