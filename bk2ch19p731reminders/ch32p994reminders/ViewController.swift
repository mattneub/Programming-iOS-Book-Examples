

import UIKit
import EventKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


class ViewController: UIViewController {
    
    let database = EKEventStore()

    func determineStatus() -> Bool {
        let type = EKEntityType.Reminder // *
        let stat = EKEventStore.authorizationStatusForEntityType(type)
        switch stat {
        case .Authorized:
            return true
        case .NotDetermined:
            database.requestAccessToEntityType(type, completion:{_ in})
            return false
        case .Restricted:
            return false
        case .Denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Calendar?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "determineStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    @IBAction func doNewReminder (sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        let cal = self.database.defaultCalendarForNewReminders()
        
        let rem = EKReminder(eventStore:self.database)
        rem.title = "Get bread"
        rem.calendar = cal
        
        // reminder can have due date
        // let's make it today
        let today = NSDate()
        let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        // day without time means "all day"
        let comps : NSCalendarUnit = [.Year, .Month, .Day]
        // start date not needed on iOS
        // rem.startDateComponents = [greg components:comps fromDate:today];
        rem.dueDateComponents = greg.components(comps, fromDate:today)
        
        // let's add an alarm
        // interesting use of location: we can make a location-based alarm
        let alarm = EKAlarm()
        let loc = EKStructuredLocation(title:"Trader Joe's")
        loc.geoLocation = CLLocation(latitude:34.271848, longitude:-119.247714)
        loc.radius = 10*1000 // metres
        alarm.structuredLocation = loc
        alarm.proximity = .Enter // "geofence": we alarm when *arriving*
        // but this will have no effect until Reminders is granted Location access...
        // and in iOS 8 it won't even ask for it until it is launched
        // also, in iOS 8 the separate background usage pref is withdrawn;
        // instead, auth of Reminders for "when in use" covers this...
        // ...because it means "this app *or one of its features* is visible on screen"
        rem.addAlarm(alarm)
        
        do {
            try self.database.saveReminder(rem, commit:true)
        } catch {
            print("save calendar \(error)")
            return
        }
        print("no error")
    }


}
