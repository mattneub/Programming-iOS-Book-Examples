

import UIKit
import EventKit
import EventKitUI

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController, EKEventViewDelegate, EKEventEditViewDelegate, EKCalendarChooserDelegate {
    let database = EKEventStore()
    var napid : String!

    func determineStatus() -> Bool {
        
        
        let type = EKEntityType.event
        let stat = EKEventStore.authorizationStatus(for:type)
        switch stat {
        case .authorized:
            return true
        case .notDetermined:
            self.database.requestAccess(to:type, completion:{_,_ in})
            return false
        case .restricted:
            return false
        case .denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Calendar?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared().open(url)
            }))
            self.present(alert, animated:true, completion:nil)
            return false
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.default().addObserver(self, selector: #selector(determineStatus), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.default().removeObserver(self)
    }

    @IBAction func createCalendar (_ sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        // obtain local source
        let locals = self.database.sources.filter {$0.sourceType == .local}
        guard let src = locals.first else {
            print("failed to find local source")
            return
        }
        let cal = EKCalendar(for:.event, eventStore:self.database)
        cal.source = src
        cal.title = "CoolCal"
        // ready to save the new calendar into the database!
        do {
            try self.database.saveCalendar(cal, commit:true)
        } catch {
            print("save calendar error: \(error)")
            return
        }
        print("no errors")
    }

    func calendar(name:String ) -> EKCalendar? {
        let cals = self.database.calendars(for:.event)
        return cals.filter {$0.title == name}.first
    }
    
    @IBAction func createSimpleEvent (_ sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        guard let cal = self.calendar(name:"CoolCal") else {
            print("failed to find calendar")
            return
        }
        
        let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let comp = NSDateComponents()
        (comp.year, comp.month, comp.day, comp.hour) = (2016,8,10,15)
        let d1 = greg.date(from:comp)!
        comp.hour = comp.hour + 1
        let d2 = greg.date(from:comp)!
        
        let ev = EKEvent(eventStore:self.database)
        ev.title = "Take a nap"
        ev.notes = "You deserve it!"
        ev.calendar = cal
        (ev.startDate, ev.endDate) = (d1,d2)
        
        // we can also easily add an alarm
        let alarm = EKAlarm(relativeOffset:-3600) // one hour before
        ev.addAlarm(alarm)
        
        do {
            try self.database.save(ev, span:.thisEvent, commit:true)
        } catch {
            print("save simple event \(error)")
            return
        }
        print("no errors")
    }

    @IBAction func createRecurringEvent (_ sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        guard let cal = self.calendar(name:"CoolCal") else {
            print("failed to find calendar")
            return
        }

        let everySunday = EKRecurrenceDayOfWeek(.sunday)
        let january = 1
        let recur = EKRecurrenceRule(
            recurrenceWith:.yearly, // every year
            interval:2, // no, every *two* years
            daysOfTheWeek:[everySunday],
            daysOfTheMonth:nil,
            monthsOfTheYear:[january],
            weeksOfTheYear:nil,
            daysOfTheYear:nil,
            setPositions: nil,
            end:nil)
        
        let ev = EKEvent(eventStore:self.database)
        ev.title = "Mysterious biennial Sunday-in-January morning ritual"
        ev.addRecurrenceRule(recur)
        ev.calendar = cal
        // need a start date and end date
        let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let comp = NSDateComponents()
        comp.year = 2016
        comp.month = 1
        comp.weekday = 1 // Sunday
        comp.weekdayOrdinal = 1 // *first* Sunday
        comp.hour = 10
        ev.startDate = greg.date(from:comp)!
        comp.hour = 11
        ev.endDate = greg.date(from:comp)!
        
        do {
            try self.database.save(ev, span:.futureEvents, commit:true)
        } catch {
            print("save recurring event \(error)")
            return
        }
        print("no errors")

    }
    
    @IBAction func searchByRange (_ sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        guard let cal = self.calendar(name:"CoolCal") else {
            print("failed to find calendar")
            return
        }
        
        let d1 = NSDate() // today
        let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let d2 = greg.date(byAdding: lend {
            (comp:NSDateComponents) in comp.year = 2
            }, to:d1)!
        let pred = self.database.predicateForEvents(withStart:
            d1, end:d2, calendars:[cal])
        var events = [EKEvent]()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.database.enumerateEvents(matching:pred) {
                (event:EKEvent, stop:UnsafeMutablePointer<ObjCBool>) in
                events += [event]
                if event.title.range(of:"nap") != nil {
                    self.napid = event.calendarItemIdentifier
                    print("found the nap")
                    // stop.memory = true
                }
            }
            events.sort {
                $0.compareStartDate(with:$1) == .orderedAscending
            }
            print(events)
            print(events.map {$0.calendarItemIdentifier})
        }
    }
    
    // ========

    @IBAction func showEventUI (_ sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        if self.napid == nil {
            print("need to search for nap event first")
            return
        }
        let ev = self.database.calendarItem(withIdentifier:self.napid) as! EKEvent

        let evc = EKEventViewController()
        evc.event = ev
        evc.allowsEditing = true
        evc.delegate = self
        // big big change
        self.navigationController?.pushViewController(evc, animated: true)
//        let nav = UINavigationController(rootViewController: evc)
//        nav.modalPresentationStyle = .popover
//        self.present(nav, animated: true, completion: nil)
//        if let pop = nav.popoverPresentationController {
//            if let v = sender as? UIView {
//                pop.sourceView = v
//                pop.sourceRect = v.bounds
//            }
//        }
    }

    func eventViewController(_ controller: EKEventViewController,
        didCompleteWith action: EKEventViewAction) {
            print("did complete with action \(action.rawValue)")
            if action == .deleted {
                self.navigationController?.popViewController(animated:true)
            }
    }

    // ========
    
    // like the photo interface, if there is no access
    // this interface will appear with a lock icon and the user must cancel

    @IBAction func editEvent (_ sender:AnyObject!) {
        let evc = EKEventEditViewController()
        evc.eventStore = self.database
        evc.editViewDelegate = self
        evc.modalPresentationStyle = .popover
        self.present(evc, animated: true, completion: nil)
        if let pop = evc.popoverPresentationController {
            if let v = sender as? UIView {
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
        }
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController,
        didCompleteWith action: EKEventEditViewAction) {
            print("did complete: \(action.rawValue), \(controller.event)")
            self.dismiss(animated:true, completion: nil)
    }
    
    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        return self.calendar(name:"CoolCal")!
    }

    // ===============

    // this one too

    @IBAction func deleteCalendar (_ sender:AnyObject!) {
        let choo = EKCalendarChooser(
            selectionStyle:.single,
            displayStyle:.allCalendars,
            entityType:.event,
            eventStore:self.database)
        choo.showsDoneButton = true
        choo.showsCancelButton = true
        choo.delegate = self
        let nav = UINavigationController(rootViewController: choo)
        nav.modalPresentationStyle = .popover
        self.present(nav, animated: true, completion: nil)
        if let pop = nav.popoverPresentationController {
            if let v = sender as? UIView {
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
        }
    }
    
    // need delegate methods in order to dismiss

    func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        self.dismiss(animated:true, completion: nil)
    }
    
    func calendarChooserDidFinish(_ chooser: EKCalendarChooser) {
        // up to us to respond
        let cals = chooser.selectedCalendars
        guard cals.count > 0 else {
            self.dismiss(animated:true, completion:nil)
            return
        }
        let calsToDelete = cals.map {$0.calendarIdentifier}
        let alert = UIAlertController(title: "Delete selected calendar?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            _ in
            for id in calsToDelete {
                if let cal = self.database.calendar(withIdentifier:id) {
                    _ = try? self.database.removeCalendar(cal, commit: true)
                }
            }
            // dismiss *everything*
            self.dismiss(animated:true, completion: nil)
        }))
        // alert sheet inside presented-or-popover
        chooser.present(alert, animated: true, completion: nil)
    }
}
