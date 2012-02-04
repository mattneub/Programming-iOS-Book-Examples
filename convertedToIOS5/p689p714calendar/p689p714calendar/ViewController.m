

#import "ViewController.h"
#import <EventKit/EventKit.h>

@interface ViewController ()
@property (nonatomic, strong) UIPopoverController* currentPop;
@property (atomic, copy) NSString* napid;
@end

@implementation ViewController
@synthesize currentPop, napid;

// run on device

// look in Calendar app afterwards to find your new events

- (IBAction)createCalendar:(id)sender {
    EKEventStore* database = [EKEventStore new];
    EKSource* src;
    for (src in database.sources)
        if (src.sourceType == EKSourceTypeLocal)
            break;
    EKCalendar* cal = [EKCalendar calendarWithEventStore:database];
    cal.source = src;
    cal.title = @"CoolCal";
    // ready to save the new calendar into the database
    NSError* err;
    BOOL ok;
    ok = [database saveCalendar:cal commit:YES error:&err];
    if (!ok) {
        NSLog(@"save calendar %@", err.localizedDescription);
        return;
    }
}

- (IBAction)createSimpleEvent:(id) sender {
    EKEventStore* database = [EKEventStore new];
    EKCalendar* cal;
    for (cal in database.calendars) // (should be using identifier)
        if ([cal.title isEqualToString: @"CoolCal"])
            break;
    if (!cal)
        return; // failed to find our calendar
    
    NSCalendar* greg = 
        [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [[NSDateComponents alloc] init];
    comp.year = 2012;
    comp.month = 8;
    comp.day = 10;
    comp.hour = 15;
    NSDate* d1 = [greg dateFromComponents:comp];
    comp.hour = comp.hour + 1;
    NSDate* d2 = [greg dateFromComponents:comp];
    
    EKEvent* ev = [EKEvent eventWithEventStore:database];
    ev.title = @"Take a nap";
    ev.notes = @"You deserve it!";
    ev.calendar = cal;
    ev.startDate = d1;
    ev.endDate = d2;
    NSError* err;
    BOOL ok = [database saveEvent:ev span:EKSpanThisEvent commit:YES error:&err];
    if (!ok) {
        NSLog(@"save event %@", err.localizedDescription);
        return;
    }
}

- (IBAction) createRecurringEvent:(id) sender {
    EKEventStore* database = [EKEventStore new];
    EKCalendar* cal;
    for (cal in database.calendars) // (should be using identifier)
        if ([cal.title isEqualToString: @"CoolCal"])
            break;
    if (!cal)
        return; // failed to find our calendar
        
    EKRecurrenceDayOfWeek* everySunday = [EKRecurrenceDayOfWeek dayOfWeek:1];
    NSNumber* january = [NSNumber numberWithInt: 1];
    EKRecurrenceRule* recur = 
    [[EKRecurrenceRule alloc] 
     initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly // every year
     interval:2 // no, every *two* years
     daysOfTheWeek:[NSArray arrayWithObject: everySunday]
     daysOfTheMonth:nil
     monthsOfTheYear:[NSArray arrayWithObject: january]
     weeksOfTheYear:nil 
     daysOfTheYear:nil 
     setPositions: nil
     end:nil];
        
    EKEvent* ev = [EKEvent eventWithEventStore:database];
    ev.title = @"Mysterious Sunday-in-January ritual";
    [ev addRecurrenceRule: recur];
    ev.calendar = cal;
    // need a start date and end date
    NSCalendar* greg = 
        [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [[NSDateComponents alloc] init];
    comp.year = 2013;
    comp.month = 1;
    comp.weekday = 1; // Sunday
    comp.weekdayOrdinal = 1; // *first* Sunday
    comp.hour = 10;
    ev.startDate = [greg dateFromComponents:comp];
    comp.hour = 11;
    ev.endDate = [greg dateFromComponents:comp];
    
    NSError* err;
    BOOL ok = [database saveEvent:ev span:EKSpanFutureEvents commit:YES error:&err];
    if (!ok) {
        NSLog(@"save event %@", err.localizedDescription);
        return;
    }
}
    
// modify example so you'll get some results
// look in console for results

- (IBAction)searchByRange:(id)sender {
    EKEventStore* database = [[EKEventStore alloc] init];
    EKCalendar* cal;
    for (cal in database.calendars) // (should be using identifier)
        if ([cal.title isEqualToString: @"CoolCal"])
            break;
    if (!cal)
        return; // failed to find our calendar

    NSDate* d1 = [NSDate date];
    // how to do calendrical arithmetic: I got this wrong in the 1st edn.
    NSCalendar* greg = 
        [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [[NSDateComponents alloc] init];
    comp.year = 1; // we're going to add 2 to the year
    NSDate* d2 = [greg dateByAddingComponents:comp toDate:d1 options:0];
    NSPredicate* pred = 
        [database predicateForEventsWithStartDate:d1 endDate:d2 
                                        calendars:[NSArray arrayWithObject:cal]];
    NSMutableArray* marr = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [database enumerateEventsMatchingPredicate:pred usingBlock:
         ^(EKEvent *event, BOOL *stop) {
             [marr addObject: event];
             if ([event.title rangeOfString:@"nap"].location != NSNotFound)
                 self.napid = event.eventIdentifier;
         }];
        [marr sortUsingSelector:@selector(compareStartDateWithEvent:)];
        NSLog(@"%@", marr);
    });
}

// universal, works on iPhone or iPad

- (IBAction) showEventUI:(id)sender {
    EKEventStore* database = [EKEventStore new];
    EKEvent* ev = [database eventWithIdentifier:self.napid];
    if (!ev) {
        NSLog(@"failed to retrieve event");
        return;
    }
    EKEventViewController* evc = [[EKEventViewController alloc] init];
    evc.event = ev;
    evc.delegate = self;
    evc.allowsEditing = YES;
    
    // on iPhone, push onto existing navigation interface
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.navigationController pushViewController:evc animated:YES];
    // on iPad, create navigation interface in popover
    else {
        UINavigationController* nc = 
        [[UINavigationController alloc] initWithRootViewController:evc];
        UIPopoverController* pop = 
        [[UIPopoverController alloc] initWithContentViewController:nc];
        self.currentPop = pop;
        [pop presentPopoverFromRect:[sender bounds] inView:sender
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action {
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    }
}

- (IBAction)editEvent:(id)sender {
    EKEventEditViewController* evc = [EKEventEditViewController new];
    EKEventStore* database = [EKEventStore new];
    evc.eventStore = database;
    evc.editViewDelegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self presentViewController:evc animated:YES completion:nil];
    // on iPad, create navigation interface in popover
    else {
        UIPopoverController* pop = 
        [[UIPopoverController alloc] initWithContentViewController:evc];
        self.currentPop = pop;
        [pop presentPopoverFromRect:[sender bounds] inView:sender
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    NSLog(@"%@", controller.event);
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    } else if (self.presentedViewController) 
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
