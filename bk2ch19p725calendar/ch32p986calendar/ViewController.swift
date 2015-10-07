

import UIKit
import EventKit
import EventKitUI

func delay(delay:Double, closure:()->()) {
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
        
        
        let type = EKEntityType.Event
        let stat = EKEventStore.authorizationStatusForEntityType(type)
        switch stat {
        case .Authorized:
            return true
        case .NotDetermined:
            self.database.requestAccessToEntityType(type, completion:{_,_ in})
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @IBAction func createCalendar (sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        // obtain local source
        let locals = self.database.sources.filter {$0.sourceType == .Local}
        guard let src = locals.first else {
            print("failed to find local source")
            return
        }
        let cal = EKCalendar(forEntityType:.Event, eventStore:self.database)
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

    func calendarWithName( name:String ) -> EKCalendar? {
        let cals = self.database.calendarsForEntityType(.Event)
        return cals.filter {$0.title == name}.first
    }
    
    @IBAction func createSimpleEvent (sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        guard let cal = self.calendarWithName("CoolCal") else {
            print("failed to find calendar")
            return
        }
        
        let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let comp = NSDateComponents()
        (comp.year, comp.month, comp.day, comp.hour) = (2016,8,10,15)
        let d1 = greg.dateFromComponents(comp)!
        comp.hour = comp.hour + 1
        let d2 = greg.dateFromComponents(comp)!
        
        let ev = EKEvent(eventStore:self.database)
        ev.title = "Take a nap"
        ev.notes = "You deserve it!"
        ev.calendar = cal
        (ev.startDate, ev.endDate) = (d1,d2)
        
        // we can also easily add an alarm
        let alarm = EKAlarm(relativeOffset:-3600) // one hour before
        ev.addAlarm(alarm)
        
        do {
            try self.database.saveEvent(ev, span:.ThisEvent, commit:true)
        } catch {
            print("save simple event \(error)")
            return
        }
        print("no errors")
    }

    @IBAction func createRecurringEvent (sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        guard let cal = self.calendarWithName("CoolCal") else {
            print("failed to find calendar")
            return
        }

        let everySunday = EKRecurrenceDayOfWeek(.Sunday)
        let january = 1
        let recur = EKRecurrenceRule(
            recurrenceWithFrequency:.Yearly, // every year
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
        ev.startDate = greg.dateFromComponents(comp)!
        comp.hour = 11
        ev.endDate = greg.dateFromComponents(comp)!
        
        do {
            try self.database.saveEvent(ev, span:.FutureEvents, commit:true)
        } catch {
            print("save recurring event \(error)")
            return
        }
        print("no errors")

    }
    
    @IBAction func searchByRange (sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        guard let cal = self.calendarWithName("CoolCal") else {
            print("failed to find calendar")
            return
        }
        
        let d1 = NSDate() // today
        let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let d2 = greg.dateByAddingComponents(lend {
            (comp:NSDateComponents) in comp.year = 2
            }, toDate:d1, options:[])!
        let pred = self.database.predicateForEventsWithStartDate(
            d1, endDate:d2, calendars:[cal])
        var events = [EKEvent]()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.database.enumerateEventsMatchingPredicate(pred) {
                (event:EKEvent, stop:UnsafeMutablePointer<ObjCBool>) in
                events += [event]
                if event.title.rangeOfString("nap") != nil {
                    self.napid = event.calendarItemIdentifier
                    print("found the nap")
                    // stop.memory = true
                }
            }
            events.sortInPlace {
                $0.compareStartDateWithEvent($1) == .OrderedAscending
            }
            print(events)
            print(events.map {$0.calendarItemIdentifier})
        }
    }
    
    // ========

    @IBAction func showEventUI (sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        if self.napid == nil {
            print("need to search for nap event first")
            return
        }
        let ev = self.database.calendarItemWithIdentifier(self.napid) as! EKEvent

        let evc = EKEventViewController()
        evc.event = ev
        evc.allowsEditing = true
        evc.delegate = self
        // big big change
        self.navigationController?.pushViewController(evc, animated: true)
//        let nav = UINavigationController(rootViewController: evc)
//        nav.modalPresentationStyle = .Popover
//        self.presentViewController(nav, animated: true, completion: nil)
//        if let pop = nav.popoverPresentationController {
//            if let v = sender as? UIView {
//                pop.sourceView = v
//                pop.sourceRect = v.bounds
//            }
//        }
    }

    func eventViewController(controller: EKEventViewController,
        didCompleteWithAction action: EKEventViewAction) {
            print("did complete with action \(action.rawValue)")
            if action == .Deleted {
                self.navigationController?.popViewControllerAnimated(true)
            }
    }

    // ========
    
    // like the photo interface, if there is no access
    // this interface will appear with a lock icon and the user must cancel

    @IBAction func editEvent (sender:AnyObject!) {
        let evc = EKEventEditViewController()
        evc.eventStore = self.database
        evc.editViewDelegate = self
        evc.modalPresentationStyle = .Popover
        self.presentViewController(evc, animated: true, completion: nil)
        if let pop = evc.popoverPresentationController {
            if let v = sender as? UIView {
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
        }
    }
    
    func eventEditViewController(controller: EKEventEditViewController,
        didCompleteWithAction action: EKEventEditViewAction) {
            print("did complete: \(action.rawValue), \(controller.event)")
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func eventEditViewControllerDefaultCalendarForNewEvents(controller: EKEventEditViewController) -> EKCalendar {
        return self.calendarWithName("CoolCal")!
    }

    // ===============

    // this one too

    @IBAction func deleteCalendar (sender:AnyObject!) {
        let choo = EKCalendarChooser(
            selectionStyle:.Single,
            displayStyle:.AllCalendars,
            entityType:.Event,
            eventStore:self.database)
        choo.showsDoneButton = true
        choo.showsCancelButton = true
        choo.delegate = self
        let nav = UINavigationController(rootViewController: choo)
        nav.modalPresentationStyle = .Popover
        self.presentViewController(nav, animated: true, completion: nil)
        if let pop = nav.popoverPresentationController {
            if let v = sender as? UIView {
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
        }
    }
    
    // need delegate methods in order to dismiss

    func calendarChooserDidCancel(calendarChooser: EKCalendarChooser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func calendarChooserDidFinish(chooser: EKCalendarChooser) {
        // up to us to respond
        let cals = chooser.selectedCalendars
        guard cals.count > 0 else {
            self.dismissViewControllerAnimated(true, completion:nil)
            return
        }
        let calsToDelete = cals.map {$0.calendarIdentifier}
        let alert = UIAlertController(title: "Delete selected calendar?", message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: {
            _ in
            for id in calsToDelete {
                if let cal = self.database.calendarWithIdentifier(id) {
                    _ = try? self.database.removeCalendar(cal, commit: true)
                }
            }
            // dismiss *everything*
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        // alert sheet inside presented-or-popover
        chooser.presentViewController(alert, animated: true, completion: nil)
    }
}
