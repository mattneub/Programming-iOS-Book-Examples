

import UIKit
import EventKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

let database = EKEventStore()

func checkForReminderAccess(andThen f:(()->())? = nil) {
    let status = EKEventStore.authorizationStatus(for:.reminder)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        database.requestAccess(to:.reminder) { ok, err in
            if ok {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        print("denied")
        break
    @unknown default: fatalError()
    }
}


class ViewController: UIViewController {
    
    var database : EKEventStore {
        return MyReminderApp.database
    }
    
    @IBAction func doNewReminder (_ sender: Any) {
        
        checkForReminderAccess {
            
            do {
        
                let cal = self.database.defaultCalendarForNewReminders()
                let rem = EKReminder(eventStore:self.database)
                rem.title = "Get bread"
                rem.calendar = cal
                
                // I don't see what effect this has; perhaps pointless
                let greg = Calendar(identifier: .gregorian)
                rem.startDateComponents = greg.dateComponents([.year, .month, .day], from: Date().advanced(by: 60*60*24)) //
                
                dont: do {
                    // break dont
                    // reminder can have due date
                    // let's make it tomorrow (making it today causes an immediate alarm which seems like a bug)
                    let greg = Calendar(identifier:.gregorian)
                    let tomorrow = greg.date(byAdding: DateComponents(day:1), to: Date())
                    // day without time means "all day"
                    let comps : Set<Calendar.Component> = [.year, .month, .day]

                    // start date not needed on iOS
                    // rem.startDateComponents = [greg components:comps fromDate:today];
                    rem.dueDateComponents = greg.dateComponents(comps, from:tomorrow!)
                    
                    break dont
                    // experimenting with alarms
                    // we do not alert merely because the reminder has a due date-time that arrives!
                    // we have to add the alert explicitly (and indeed the Reminders app does that)
                    do {
                        let in2min = greg.date(byAdding: DateComponents(minute:2), to: Date())
                        let comps : Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
                        rem.dueDateComponents = greg.dateComponents(comps, from:in2min!)
                        let alarm = EKAlarm(absoluteDate: in2min!)
                        rem.addAlarm(alarm)
                    }

                }
                
                dont2 : do {
                    // break dont2
                    // interesting use of location: we can make a location-based alarm
                    // NB if you do this without also doing preceding,
                    // message reads "Behavior is undefined if you set a time interval (duration) alarm trigger without a due date on the reminder!"
                    // but that makes no sense to me: why shouldn't we remind at a location...
                    // without also specifying a day?
                    // and user can perfectly well do this in Reminders app
                    // and I'm not setting a time interval alarm anyway! it being set to 0 for me
                    // plus this is exactly the syntax shown in the WWDC 2012 video on the topic
                    let alarm = EKAlarm()
                    let loc = EKStructuredLocation(title:"Trader Joe's")
                    loc.geoLocation = CLLocation(latitude:34.271848, longitude:-119.247714)
                    loc.radius = 10*1000 // metres
                    alarm.structuredLocation = loc
                    alarm.proximity = .enter // "geofence": we alarm when *arriving*
                    // but this will have no effect until Reminders is granted Location access...
                    // and in iOS 8 it won't even ask for it until it is launched
                    // also, in iOS 8 the separate background usage pref is withdrawn;
                    // instead, auth of Reminders for "when in use" covers this...
                    // ...because it means "this app *or one of its features* is visible on screen"
                    rem.addAlarm(alarm)
                }
                
                try self.database.save(rem, commit:true)
                print("no error")
                delay(1) {
                    let pred = self.database.predicateForReminders(in: nil)
                    self.database.fetchReminders(matching: pred) { rems in
                        if let rems = rems {
                            let alarms = rems.filter { $0.title == "Get bread" }.map {$0.alarms}
                            print(alarms as Any) // nil
                        }
                    }
                }

            } catch {
                print("save calendar \(error)")
                return
            }

            
        }
    }


}
