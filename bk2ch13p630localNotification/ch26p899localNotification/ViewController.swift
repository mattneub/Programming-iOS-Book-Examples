

import UIKit

class ViewController: UIViewController {

    @IBAction func doButton(sender:AnyObject) {
        print("checking for notification permissions")
        if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
        // but you don't get enough info from this to make an intelligence decision
            if settings.types.contains(.Alert) {
                print("alert enabled \(settings.types.rawValue)")
            } else {
                print("no alerts")
                // but I would never bail out here, because you might still get into notif center / lock screen
            }
            // I can't specify it, but there are situations where this whole thing gets out of sync
        }
        
        print("creating local notification")
        let ln = UILocalNotification()
        ln.alertBody = "Time for another cup of coffee!"
        ln.category = "coffee" // causes Options button to spring magically to life in alert
        // Options button will offer Open, action buttons, Close
        ln.fireDate = NSDate(timeIntervalSinceNow:15)
        ln.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(ln)
    }
    /*
    If user has denied alerts/sounds, trying to schedule the above notification...
    ...will log in the console for each of those, but no harm done
    */
    
}
