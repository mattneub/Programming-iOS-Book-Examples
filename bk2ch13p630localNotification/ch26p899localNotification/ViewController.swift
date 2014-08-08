

import UIKit

class ViewController: UIViewController {

    @IBAction func doButton(sender:AnyObject) {
        println("creating local notification")
        let ln = UILocalNotification()
        ln.alertBody = "Time for another cup of coffee!"
//        ln.alertAction = "Yum" // has no effect
//        ln.hasAction = false // try false; has no effect
        ln.category = "coffee" // causes Options button to spring magically to life in alert
        // Options button will offer Open, Yum, Close
        ln.fireDate = NSDate(timeIntervalSinceNow:15)
        ln.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(ln)
    }
    /*
    If user has denied alerts/sounds, trying to schedule the above notification...
    ...will log in the console for each of those, but no harm done
    */
    
    /*
    By default, if there is no action, if we are not in forground, in an alert, user will see Close and Open buttons
    Tapping Close does nothing
    Tapping Open brings us to the front but does NOT tell us that the notification is the cause...!
    */
}
