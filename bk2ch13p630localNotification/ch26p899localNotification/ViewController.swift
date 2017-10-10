

import UIKit
import UserNotifications



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



class MyUserNotificationHelper : NSObject {
    let categoryIdentifier = "coffee"

    func kickThingsOff() {
        // artificially, I'm going to start by clearing out any categories
        // otherwise, it's hard to test, because even after deleting the app...
        // the categories stick around and continue to be used
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([])
        
        // not so artificially, before we do anything else let's clear out all notifications
        // cool new iOS 10 feature, let's use it
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        // start the process
        self.checkAuthorization()
    }
    
    private func checkAuthorization() {
        print("checking for notification permissions")
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.doAuthorization()
            case .denied:
                print("denied, giving up")
            break // nothing to do, pointless to go on
            case .authorized:
                self.checkCategories() // prepare create notification
            }
        }
    }
    
    private func doAuthorization() {
        print("asking for authorization")
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { ok, err in
            if let err = err {
                print(err)
                return
            }
            if ok {
                self.checkCategories()
            } else {
                print("user refused authorization")
            }
        }
    }
    
    private func checkCategories() {
        print("checking categories")
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationCategories {
            cats in
            if cats.count == 0 {
                self.configureCategory()
            }
            self.createNotification()
        }
    }
    
    // how action buttons are displayed:
    // if the device has 3D touch, must 3D touch
    // otherwise:
    // for a banner/alert: there is a "drag" bar and you drag downward
    // in the notification center: you drag left and there is a View button, tap it
    
    private func configureCategory() {
        // return; // see what it's like if there's no category
        print("configuring category")
        
        // create actions
        // options are:
        // foreground (if not, background)
        // destructive (if not, normal appearance)
        // authenticationRequired (if so, cannot just do directly from lock screen)
        let action1 = UNNotificationAction(identifier: "snooze", title: "Snooze")
        let action2 = UNNotificationAction(identifier: "reconfigure",
                                           title: "Reconfigure", options: [.foreground])
        let action3 = UNTextInputNotificationAction(identifier: "message", title: "Message", options: [], textInputButtonTitle: "Message", textInputPlaceholder: "message")
        
        // combine actions into category
        // the key option here is customDismissAction
        // allows us to hear about it if user dismisses
        // to put it another way: if we don't have this, we won't hear about it when user dismisses
        var customDismiss : Bool { return false }
        let cat = UNNotificationCategory(identifier: self.categoryIdentifier, actions: [action1, action2], intentIdentifiers: [], options: customDismiss ? [.customDismissAction] : [])
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([cat])
        
        _ = action3
    }
    
    fileprivate func createNotification() {
        print("creating notification")
        
        // need trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        // need content
        let content = UNMutableNotificationContent()
        content.title = "Caffeine!" // title now always appears
        // content.subtitle = "whatever" // new
        content.body = "Time for another cup of coffee!"
        content.sound = UNNotificationSound.default()
        
        // if we want to see actions, we must add category identifier
        content.categoryIdentifier = self.categoryIdentifier
        
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
        let req = UNNotificationRequest(identifier: "coffeeNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(req)
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
        
        print("received notification while active")
        
        completionHandler([.sound, .alert]) // go for it, system!
        
        // oooh oooh I accidentally learned something
        // if Do Not Disturb is on, no notifications interrupt
        // they go in notification center but they don't appear in normal interface
        
    }
    
    // everything else that happens is funneled through here
    // we can find out everything we need to know by examining the response
    // one way or another, we must _must_ call completionHandler
    // need to be fast, esp. as we may have been woken in the background to handle this
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let id = response.actionIdentifier // can be default, dismiss, or one of ours
        print("user action was: \(id)")
        
        if id == "snooze" {
            delay(1) { // because otherwise the image doesn't show
                self.createNotification()
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
        let item = UIApplicationShortcutItem(type: "coffee.schedule", localizedTitle: "Coffee Reminder", localizedSubtitle: subtitle, icon: UIApplicationShortcutIcon(templateImageName: "cup"), userInfo: ["time":time])
        UIApplication.shared.shortcutItems = [item]
        
    }
    
}
