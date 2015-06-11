

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


class ViewController: UIViewController, EKEventViewDelegate, EKEventEditViewDelegate, EKCalendarChooserDelegate {
    var database = EKEventStore()
    var napid : String!

    func determineStatus() -> Bool {
        let type = EKEntityTypeEvent
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

    @IBAction func createCalendar (sender:AnyObject!) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        // obtain local source
        var src : EKSource! = nil
        for source in self.database.sources() as! [EKSource] {
            if source.sourceType.value == EKSourceTypeLocal.value {
                src = source
                break
            }
        }
        if src == nil {
            println("failed to find local source")
            return
        }
        let cal = EKCalendar(forEntityType:EKEntityTypeEvent,
            eventStore:self.database)
        cal.source = src
        cal.title = "CoolCal"
        // ready to save the new calendar into the database!
        var err : NSError?
        let ok = self.database.saveCalendar(cal, commit:true, error:&err)
        if !ok {
            println("save calendar error: \(err!.localizedDescription)")
            return
        }
        println("no errors")
    }

    func calendarWithName( name:String ) -> EKCalendar? {
        let calendars = self.database.calendarsForEntityType(EKEntityTypeEvent) as! [EKCalendar]
        for cal in calendars { // (should be using identifier)
            if cal.title == name {
                return cal
            }
        }
        println ("failed to find calendar")
        return nil
    }
    
    @IBAction func createSimpleEvent (sender:AnyObject!) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        
        let cal : EKCalendar! = self.calendarWithName("CoolCal")
        if cal == nil {
            return
        }
        
        let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let comp = NSDateComponents()
        comp.year = 2015
        comp.month = 8
        comp.day = 10
        comp.hour = 15
        let d1 = greg.dateFromComponents(comp)
        comp.hour = comp.hour + 1
        let d2 = greg.dateFromComponents(comp)
        
        let ev = EKEvent(eventStore:self.database)
        ev.title = "Take a nap"
        ev.notes = "You deserve it!"
        ev.calendar = cal
        ev.startDate = d1
        ev.endDate = d2
        
        // we can also easily add an alarm
        let alarm = EKAlarm(relativeOffset:-3600) // one hour before
        ev.addAlarm(alarm)
        
        var err : NSError?
        let ok = self.database.saveEvent(ev, span:EKSpanThisEvent, commit:true, error:&err)
        if !ok {
            println("save simple event \(err!.localizedDescription)")
            return
        }
        println("no errors")
    }

    @IBAction func createRecurringEvent (sender:AnyObject!) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        
        let cal : EKCalendar! = self.calendarWithName("CoolCal")
        if cal == nil {
            return
        }

        let everySunday = EKRecurrenceDayOfWeek(1)
        let january = 1
        let recur = EKRecurrenceRule(
            recurrenceWithFrequency:EKRecurrenceFrequencyYearly, // every year
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
        comp.year = 2015
        comp.month = 1
        comp.weekday = 1 // Sunday
        comp.weekdayOrdinal = 1 // *first* Sunday
        comp.hour = 10
        ev.startDate = greg.dateFromComponents(comp)
        comp.hour = 11
        ev.endDate = greg.dateFromComponents(comp)
        
        var err : NSError?
        let ok = self.database.saveEvent(ev, span:EKSpanFutureEvents, commit:true, error:&err)
        if !ok {
            println("save recurring event \(err!.localizedDescription)")
            return
        }
        println("no errors")
    }
    
    @IBAction func searchByRange (sender:AnyObject!) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        
        let cal : EKCalendar! = self.calendarWithName("CoolCal")
        if cal == nil {
            return
        }
        
        let d1 = NSDate() // today
        let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let comp = NSDateComponents()
        comp.year = 1 // we're going to add 1 to the year
        let d2 = greg.dateByAddingComponents(comp, toDate:d1, options:nil)
        let pred = self.database.predicateForEventsWithStartDate(d1, endDate:d2,
                calendars:[cal])
        var events = [EKEvent]()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.database.enumerateEventsMatchingPredicate(pred) {
                (event:EKEvent!, stop:UnsafeMutablePointer<ObjCBool>) in
                    events += [event]
                    if (event.title as NSString).rangeOfString("nap").location != NSNotFound {
                        self.napid = event.calendarItemIdentifier
                        println("found the nap")
                    }
            }
            sort(&events) {return $0.compareStartDateWithEvent($1) == .OrderedAscending}
            // println(events)
        }
    }
    
    // ========

    @IBAction func showEventUI (sender:AnyObject!) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        if self.napid == nil {
            println("need to search for nap event first")
            return
        }
        let ev = self.database.calendarItemWithIdentifier(self.napid) as! EKEvent!
        if ev == nil {
            println("failed to retrieve event")
            return
        }

        let evc = EKEventViewController()
        evc.event = ev
        evc.allowsEditing = true
        evc.delegate = self
        let nav = UINavigationController(rootViewController: evc)
        nav.modalPresentationStyle = .Popover
        self.presentViewController(nav, animated: true, completion: nil)
        if let pop = nav.popoverPresentationController {
            if let v = sender as? UIView {
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
        }
    }

    func eventViewController(controller: EKEventViewController!,
        didCompleteWithAction action: EKEventViewAction) {
            println("did complete with action \(action.value)")
            controller.dismissViewControllerAnimated(true, completion: nil)
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
    
    func eventEditViewController(controller: EKEventEditViewController!,
        didCompleteWithAction action: EKEventEditViewAction) {
            println("did complete: \(action.value), \(controller.event)")
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func eventEditViewControllerDefaultCalendarForNewEvents(controller: EKEventEditViewController!) -> EKCalendar! {
        return self.calendarWithName("CoolCal")
    }

    // ===============

    // this one too

    @IBAction func deleteCalendar (sender:AnyObject!) {
        let choo = EKCalendarChooser(
            selectionStyle:EKCalendarChooserSelectionStyleSingle,
            displayStyle:EKCalendarChooserDisplayAllCalendars,
            entityType:EKEntityTypeEvent,
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

    func calendarChooserDidCancel(calendarChooser: EKCalendarChooser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func calendarChooserDidFinish(calendarChooser: EKCalendarChooser!) {
        // up to us to respond
        let cals = calendarChooser.selectedCalendars as! Set<EKCalendar>!
            if cals != nil && cals.count > 0 {
                let calsToDelete = map(cals!) {$0.calendarIdentifier}
                let alert = UIAlertController(title: "Delete selected calendar?", message: nil, preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: {
                    _ in
                    for ident in calsToDelete {
                        if let cal = self.database.calendarWithIdentifier(ident as String) {
                            self.database.removeCalendar(cal, commit: true, error: nil)
                        }
                    }
                    // dismiss *everything*
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                // alert sheet inside presented-or-popover
                calendarChooser.presentViewController(alert, animated: true, completion: nil)
                return
            }
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}
