

import UIKit
import EventKit

class ViewController: UIViewController {
    
    var authDone = false
    var database : EKEventStore!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let type = EKEntityTypeReminder // *
        if !self.authDone {
            self.authDone = true
            let stat = EKEventStore.authorizationStatusForEntityType(type)
            switch stat {
            case .Denied, .Restricted:
                println("no access")
            case .Authorized, .NotDetermined:
                let database = EKEventStore()
                database.requestAccessToEntityType(type) {
                    (granted:Bool, err:NSError!) in
                    dispatch_async(dispatch_get_main_queue()) {
                        if granted {
                            self.database = database
                        } else {
                            println(err)
                        }
                    }
                }
            }
        }
    }

    @IBAction func doNewReminder (sender:AnyObject!) {
        if self.database == nil {
            println("no access")
            return
        }
        
        let cal = self.database.defaultCalendarForNewReminders()
        if cal == nil {
            println("failed to find calendar")
            return
        }
        
        let rem = EKReminder(eventStore:self.database)
        rem.title = "Get bread"
        rem.calendar = cal
        
        // reminder can have due date
        // let's make it today
        let today = NSDate()
        let greg = NSCalendar(calendarIdentifier:NSGregorianCalendar)
        // day without time means "all day"
        let comps : NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit
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
        alarm.proximity = EKAlarmProximityEnter // "geofence": we alarm when *arriving*
        // but this will have no effect until Reminders is granted Location access...
        // and in iOS 8 it won't even ask for it until it is launched
        // also, in iOS 8 the separate background usage pref is withdrawn;
        // instead, auth of Reminders for "when in use" covers this...
        // ...because it means "this app *or one of its features* is visible on screen"
        rem.addAlarm(alarm)
        
        var err : NSError?
        let ok = self.database.saveReminder(rem, commit:true, error:&err)
        if !ok {
            println("save calendar \(err!.localizedDescription)")
            return
        }
        println("no error")
    }


}
