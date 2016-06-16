

import UIKit
import EventKit

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.after(when: when, execute: closure)
}


class ViewController: UIViewController {
    
    let database = EKEventStore()

    @discardableResult
    func determineStatus() -> Bool {
        let type = EKEntityType.reminder // *
        let stat = EKEventStore.authorizationStatus(for:type)
        switch stat {
        case .authorized:
            return true
        case .notDetermined:
            database.requestAccess(to:type) {_ in}
            return false
        case .restricted:
            return false
        case .denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Calendar?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "OK", style: .default) {
                _ in
                let url = URL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared().open(url)
            })
            self.present(alert, animated:true)
            return false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NotificationCenter.default().addObserver(self, selector: #selector(determineStatus), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    @IBAction func doNewReminder (_ sender:AnyObject!) {
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
        let today = Date()
        let greg = Calendar(calendarIdentifier:Calendar.Identifier.gregorian)!
        // day without time means "all day"
        let comps : Calendar.Unit = [.year, .month, .day]
        // start date not needed on iOS
        // rem.startDateComponents = [greg components:comps fromDate:today];
        rem.dueDateComponents = greg.components(comps, from:today)
        
        // let's add an alarm
        // interesting use of location: we can make a location-based alarm
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
        
        do {
            try self.database.save(rem, commit:true)
        } catch {
            print("save calendar \(error)")
            return
        }
        print("no error")
    }


}
