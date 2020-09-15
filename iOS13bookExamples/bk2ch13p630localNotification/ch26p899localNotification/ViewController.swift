

import UIKit
import UserNotifications
import os.log



extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}


// NB this class is _defined_ here, but the instance is created by the app delegate
// and is stored there as its `notifHelper`
// this is especially so that delegate messages will work

class MyUserNotificationHelper : NSObject {
    let categoryIdentifier = "coffee"
    
    var clearAllCategories = false
    var clearAllNotifications = false
    func kickThingsOff() {
        let center = UNUserNotificationCenter.current()

        // artificially, might need to start by clearing out any categories
        // otherwise, it's hard to test, because even after deleting the app...
        // the categories stick around and continue to be used
        if clearAllCategories {
            center.setNotificationCategories([])
        }
        
        // might want to clear out all notifications
        if clearAllNotifications {
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
        }
        
        // start the process
        self.checkAuthorization()
    }
    
    private func checkAuthorization() {
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings {
            settings in
            let stats = ["not determined", "denied", "authorized", "provisional"]
            print("checking authorization; it is", stats[settings.authorizationStatus.rawValue])
            switch settings.authorizationStatus {
            case .notDetermined:
                self.doAuthorization() // will checkCategories() if we get it
            case .denied:
                // print("denied, giving up")
                break // nothing to do, pointless to go on
            case .authorized, .provisional:
                self.checkCategories() // prepare to create notification
            @unknown default:
                fatalError()
            }
            
        }
    }
    
    var provisional = false
    private func doAuthorization() {
        print("asking for authorization")
        
        let center = UNUserNotificationCenter.current()
        var opts : UNAuthorizationOptions = [.alert, .sound, .badge, .providesAppNotificationSettings]
        if provisional {
            opts.insert(.provisional)
        }
        
        center.requestAuthorization(options: opts) { ok, err in
            if let err = err {
                print(err)
                return
            }
            if ok {
                print("we got authorization")
                self.checkCategories()
            } else {
                print("user refused authorization")
            }
        }
    }
    
    private func checkCategories() {
        print("checking categories")
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationCategories { cats in
            var cats = cats
            print("we have \(cats.count) categories")
            // this little dance is not really necessary here; just showing the syntax
            let newcat = self.configureCategory()
            cats.formUnion(newcat)
            center.setNotificationCategories(cats)
            // at last! here we go...
            // NB I am pretending we emit only one notification! thus we know automatically what to do
            self.createNotification()
        }
    }
    
    // how action buttons are displayed:
    // if the device has 3D touch, must 3D touch
    // otherwise:
    // for a banner/alert: there is a "drag" bar and you drag downward
    // in the notification center: you drag left and there is a View button, tap it
    
    var customDismiss = true
    private func configureCategory() -> [UNNotificationCategory] {
        // return [] // see what it's like if there's no category
        print("configuring category")
        
        // new in iOS 12: if we have a notification content extension, we don't need
        // to preconfigure the custom buttons in the category! moved that code into the extension
        
        let action1 = UNNotificationAction(identifier: "snooze", title: "Snooze")
        let action2 = UNNotificationAction(identifier: "reconfigure",
                                           title: "Reconfigure", options: [.foreground])
        let action3 = UNTextInputNotificationAction(identifier: "message", title: "Message", options: [], textInputButtonTitle: "Message", textInputPlaceholder: "message")
        var actions = [action1, action2]
        // but the above is just to test the syntax
        actions = []
        
        // if we don't have customDismissAction, we won't hear about it when user dismisses
        // let cat = UNNotificationCategory(identifier: self.categoryIdentifier, actions: [], intentIdentifiers: [], options: customDismiss ? [.customDismissAction] : [])
        let opts : UNNotificationCategoryOptions = customDismiss ? [.customDismissAction] : []
        let summary = "%u more reminders from %@"
        let cat = UNNotificationCategory(identifier: self.categoryIdentifier, actions: actions, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: nil, categorySummaryFormat: summary, options: opts)
        let cat2 = UNNotificationCategory(identifier: self.categoryIdentifier, actions: actions, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "hungadunga", categorySummaryFormat: nil, options: opts)
        print("are those two categories identical?", cat == cat2)
        // so what happens if two categories have the same identifier???
        // return [cat, cat2]
        return [cat]
    }
    
    fileprivate func createNotification() {
        print("creating notification at ", Date())
        
        // need trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        // need content
        let content = UNMutableNotificationContent()
        content.title = "Caffeine!" // title now always appears
        // content.subtitle = "whatever" // new
        content.body = "Time for another cup of coffee!" // + " " + Date().description
        content.sound = UNNotificationSound.default
        content.sound = UNNotificationSound(named: UNNotificationSoundName("test.aif"))
        content.badge = 20
        
        // if we want to see actions, we must add category identifier
        content.categoryIdentifier = self.categoryIdentifier
        
        content.summaryArgument = "Matt"
        
        // new iOS 10 feature: attachments! AIFF, JPEG, or MPEG
        let url = Bundle.main.url(forResource: "cup2", withExtension: "jpg")!
        // a failed experiment
//        let rect = CGRect(0,0,1,1).dictionaryRepresentation
//        let dict : [AnyHashable:Any] = [UNNotificationAttachmentOptionsThumbnailClippingRectKey:rect]
        
        if let att = try? UNNotificationAttachment(identifier: "cup", url: url, options:nil) {
            content.attachments = [att]
//            let url = Bundle.main.url(forResource: "test", withExtension: "aif")!
//            if let att2 = try? UNNotificationAttachment(identifier: "test", url: url) {
//                content.attachments = [att2] // I tried [att, att2] but there was no interface for the sound
//                // so, despite the name, I suggest having only one attachment!
//            } else {
//                print("failed to make second attachment")
//            }
        } else {
            print("failed to make attachment")
        }
        
        // combine them into a request
        // NB if I use the same identifier, each notification removes the pending one with that identifier
        // that makes it hard to test grouping :)
        var useUUID : Bool { return true }
        let uuid = UUID()
        let id = "coffeeTime" + (useUUID ? uuid.uuidString : "")
        let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(req)
        
        // test nextTriggerDate bug
        print("scheduling at", Date())
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            print("checking at", Date())
            UNUserNotificationCenter.current().getPendingNotificationRequests {
                arr in let arr = arr
                guard arr.count > 0 else { print("no pending requests"); return }
                if let req = arr[0].trigger as? UNTimeIntervalNotificationTrigger {
                    let fd = req.nextTriggerDate()
                    print("trigger date", fd as Any)
                }
            }
        }

    }
}

extension MyUserNotificationHelper : UNUserNotificationCenterDelegate {
    
    // just two optional methods
    
    // called if we are in the foreground when our notification fires
    // new in iOS 10, we have the option to have system present the notification!
    // one way or another, however, we _must_ call completionHandler
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("received notification while active", Date())
        
        // completionHandler([.sound, .alert]) // go for it, system!
        completionHandler([])
        
        // oooh oooh I accidentally learned something
        // if Do Not Disturb is on, no notifications interrupt
        // they go in notification center but they don't appear in normal interface
        
    }
    
    // everything else that happens is funneled through here
    // we can find out everything we need to know by examining the response
    // one way or another, we must _must_ call completionHandler
    // need to be fast, esp. as we may have been woken in the background to handle this
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        os_log("%{public}@ %{public}@", log: log, self, #function)
        // the idea is to show that we are called whether we were in background or not running at all
        // and indeed we are
        
        print(UIApplication.shared.applicationState.rawValue)
        let id = response.actionIdentifier // can be default, dismiss, or one of ours
        print("user action was: \(id)")
        print("on main thread", Thread.isMainThread)
        
        if id == "snooze" {
            var id = UIBackgroundTaskIdentifier.invalid
            id = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(id)
            }
            delay(0.1) {
                print("got snooze, responding")
                self.createNotification()
                UIApplication.shared.endBackgroundTask(id)
            }
        }
        
        // if we need more info, we can also fetch response.notification
        
        // if this was text input, the response will be a UNTextInputNotificationAction
        
        if let textresponse = response as? UNTextInputNotificationResponse {
            let text = textresponse.userText
            print("user text was \(text)")
        }
        
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print("I should be opening my settings screen now!")
        // called before we become active
        let id = "settings"
        UIApplication.shared.keyWindow?.rootViewController?.performSegue(withIdentifier: id, sender: nil)
    }

    
}


class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    

    @IBAction func doButton(_ sender: Any) {
        let del = UIApplication.shared.delegate as! AppDelegate
        del.notifHelper.kickThingsOff()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // pretend that we allow the user to set a reminder interval...
        // ... and that we permit the user to have a favorite interval
        // we can added that to our app's quick actions
        let subtitle = "In 1 hour..."
        let time = 60
        let item = UIApplicationShortcutItem(type: "coffee.schedule", localizedTitle: "Coffee Reminder", localizedSubtitle: subtitle, icon: UIApplicationShortcutIcon(templateImageName: "cup"), userInfo: ["time":time as NSNumber])
        UIApplication.shared.shortcutItems = [item]
        
    }
    
    @IBAction func unwind (_ : UIStoryboardSegue) {}
    
}
