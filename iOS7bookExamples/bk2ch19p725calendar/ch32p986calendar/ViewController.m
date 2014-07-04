

#import "ViewController.h"
@import EventKit;
@import EventKitUI;

@interface ViewController () <EKEventViewDelegate, EKEventEditViewDelegate, UINavigationControllerDelegate, EKCalendarChooserDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) EKEventStore* database;
@property (nonatomic, copy) NSString* napid;
@property (nonatomic, strong) UIPopoverController* currentPop;
@property (nonatomic, strong) NSSet* calsToDelete;
@end

@implementation ViewController {
    BOOL _authDone;
}

/*
 WARNING: I don't know if this is a bug or not, but if your iPhone
 uses iCloud, gmail, or similar calendar synching, you have no access
 to local calendars (even if you create one).
 However, these examples use the local calendar
 because I am reluctant to risk damaging your iCloud calendar.
 So these examples won't work on your iPhone unless you turn off
 every form of wireless calendar synching.
 Oddly, I think the examples *do* work on the iPad!
 */

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    EKEntityType type = EKEntityTypeEvent;
    if (!self->_authDone) {
        self->_authDone = YES;
        EKAuthorizationStatus stat = [EKEventStore authorizationStatusForEntityType:type];
        switch (stat) {
            case EKAuthorizationStatusDenied:
            case EKAuthorizationStatusRestricted: {
                NSLog(@"%@", @"no access");
                break;
            }
            case EKAuthorizationStatusAuthorized:
            case EKAuthorizationStatusNotDetermined: {
                EKEventStore* database = [EKEventStore new];
                [database requestAccessToEntityType:type completion:
                 ^(BOOL granted, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (granted)
                             self.database = database;
                         else
                             NSLog(@"error: %@", error);
                     });
                }];
            }
        }
    }
}

- (IBAction)createCalendar:(id)sender {
    if (!self.database)
        return;
    // obtain local source
    EKSource* src = nil;
    for (src in self.database.sources)
        if (src.sourceType == EKSourceTypeLocal)
            break;
    if (!src) {
        NSLog(@"%@", @"failed to find local source");
        return;
    }
    EKCalendar* cal = [EKCalendar calendarForEntityType:EKEntityTypeEvent
                                             eventStore:self.database];
    cal.source = src;
    cal.title = @"CoolCal";
    // ready to save the new calendar into the database!
    NSError* err;
    BOOL ok = [self.database saveCalendar:cal commit:YES error:&err];
    if (!ok) {
        NSLog(@"save calendar %@", err.localizedDescription);
        return;
    }
    NSLog(@"%@", @"no errors");
}

- (EKCalendar*) calendarWithName: (NSString*) name {
    EKCalendar* cal = nil;
    NSArray* calendars = [self.database calendarsForEntityType:EKEntityTypeEvent];
    NSLog(@"%@", calendars);
    for (cal in calendars) // (should be using identifier)
        if ([cal.title isEqualToString: name])
            return cal;
    if (!cal)
        NSLog(@"%@", @"failed to find calendar");
    return nil;
}

- (IBAction)createSimpleEvent:(id) sender {
    if (!self.database)
        return;
    
    EKCalendar* cal = [self calendarWithName: @"CoolCal"];
    if (!cal)
        return;
    
    NSCalendar* greg =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [[NSDateComponents alloc] init];
    comp.year = 2014;
    comp.month = 8;
    comp.day = 10;
    comp.hour = 15;
    NSDate* d1 = [greg dateFromComponents:comp];
    comp.hour = comp.hour + 1;
    NSDate* d2 = [greg dateFromComponents:comp];
    
    EKEvent* ev = [EKEvent eventWithEventStore:self.database];
    ev.title = @"Take a nap";
    ev.notes = @"You deserve it!";
    ev.calendar = cal;
    ev.startDate = d1;
    ev.endDate = d2;
    
    // we can also easily add an alarm
    EKAlarm* alarm = [EKAlarm alarmWithRelativeOffset:-3600]; // one hour before
    [ev addAlarm:alarm];
    
    NSError* err;
    BOOL ok = [self.database saveEvent:ev span:EKSpanThisEvent commit:YES error:&err];
    if (!ok) {
        NSLog(@"save simple event %@", err.localizedDescription);
        return;
    }
    NSLog(@"%@", @"no errors");
}

- (IBAction) createRecurringEvent:(id) sender {
    if (!self.database)
        return;
    
    EKCalendar* cal = [self calendarWithName: @"CoolCal"];
    if (!cal)
        return;
    
    EKRecurrenceDayOfWeek* everySunday = [EKRecurrenceDayOfWeek dayOfWeek:1];
    NSNumber* january = @1;
    EKRecurrenceRule* recur =
    [[EKRecurrenceRule alloc]
     initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly // every year
     interval:2 // no, every *two* years
     daysOfTheWeek:@[everySunday]
     daysOfTheMonth:nil
     monthsOfTheYear:@[january]
     weeksOfTheYear:nil
     daysOfTheYear:nil
     setPositions: nil
     end:nil];
    
    EKEvent* ev = [EKEvent eventWithEventStore:self.database];
    ev.title = @"Mysterious biennial Sunday-in-January morning ritual";
    [ev addRecurrenceRule: recur];
    ev.calendar = cal;
    // need a start date and end date
    NSCalendar* greg =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [[NSDateComponents alloc] init];
    comp.year = 2014;
    comp.month = 1;
    comp.weekday = 1; // Sunday
    comp.weekdayOrdinal = 1; // *first* Sunday
    comp.hour = 10;
    ev.startDate = [greg dateFromComponents:comp];
    comp.hour = 11;
    ev.endDate = [greg dateFromComponents:comp];
    
    NSError* err;
    BOOL ok = [self.database saveEvent:ev span:EKSpanFutureEvents commit:YES error:&err];
    if (!ok) {
        NSLog(@"save recurring event %@", err.localizedDescription);
        return;
    }
    NSLog(@"%@", @"no errors");
}

- (IBAction)searchByRange:(id)sender {
    if (!self.database)
        return;
    
    EKCalendar* cal = [self calendarWithName: @"CoolCal"];
    if (!cal)
        return;
    
    NSDate* d1 = [NSDate date]; // today
    NSCalendar* greg =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [NSDateComponents new];
    comp.year = 1; // we're going to add 1 to the year
    NSDate* d2 = [greg dateByAddingComponents:comp toDate:d1 options:0];
    NSPredicate* pred =
    [self.database predicateForEventsWithStartDate:d1 endDate:d2
                                         calendars:@[cal]];
    NSMutableArray* marr = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.database enumerateEventsMatchingPredicate:pred usingBlock:
         ^(EKEvent *event, BOOL *stop) {
             [marr addObject: event];
             if ([event.title rangeOfString:@"nap"].location != NSNotFound)
                 self.napid = event.calendarItemIdentifier;
         }];
        [marr sortUsingSelector:@selector(compareStartDateWithEvent:)];
        NSLog(@"%@", marr);
    });
}

// ======================================

// universal, works on iPhone or iPad

- (IBAction) showEventUI:(id)sender {
    if (!self.database)
        return;
    if (!self.napid) {
        NSLog(@"need to search for nap event first");
        return;
    }
    
    EKEvent* ev = (EKEvent*)[self.database calendarItemWithIdentifier:self.napid];
    if (!ev) {
        NSLog(@"failed to retrieve event");
        return;
    }
    EKEventViewController* evc = [EKEventViewController new];
    evc.event = ev;
    evc.delegate = self;
    // evc.allowsEditing = NO;
    
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
    NSLog(@"did complete with action %d", action);
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    }
}

// ======================================

// like the photo interface, if there is no access
// this interface will appear with a lock icon and the user must cancel

- (IBAction)editEvent:(id)sender {
    EKEventEditViewController* evc = [EKEventEditViewController new];
    evc.eventStore = self.database;
    evc.editViewDelegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self presentViewController:evc animated:YES completion:nil];
    else {
        UIPopoverController* pop =
        [[UIPopoverController alloc] initWithContentViewController:evc];
        self.currentPop = pop;
        [pop presentPopoverFromRect:[sender bounds] inView:sender
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)eventEditViewController:(EKEventEditViewController *)controller
         didCompleteWithAction:(EKEventEditViewAction)action {
    NSLog(@"did complete: %d %@", action, controller.event);
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    } else if (self.presentedViewController)
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
    return [self calendarWithName:@"CoolCal"];
}

// ==========================

// this one too

- (IBAction)deleteCalendar:(id)sender {
    EKCalendarChooser* choo =
    [[EKCalendarChooser alloc]
     initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle
     displayStyle:EKCalendarChooserDisplayAllCalendars
     entityType:EKEntityTypeEvent
     eventStore:self.database];
    choo.showsDoneButton = YES;
    choo.showsCancelButton = YES;
    choo.delegate = self;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:choo];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self presentViewController:nav animated:YES completion:nil];
    // on iPad, create navigation interface in popover
    else {
        UIPopoverController* pop =
        [[UIPopoverController alloc] initWithContentViewController:nav];
        self.currentPop = pop;
        [pop presentPopoverFromRect:[sender bounds] inView:sender
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)calendarChooserDidCancel:(EKCalendarChooser *)calendarChooser {
    NSLog(@"chooser cancel");
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    } else if (self.presentedViewController)
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)calendarChooserDidFinish:(EKCalendarChooser *)calendarChooser {
    NSLog(@"chooser finish");
    NSSet* cals = calendarChooser.selectedCalendars;
    if (cals && cals.count) {
        self.calsToDelete = [cals valueForKey:@"calendarIdentifier"];
        UIActionSheet* act = [[UIActionSheet alloc] initWithTitle:@"Delete selected calendar?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
        [act showInView:calendarChooser.view];
        return;
    }
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    } else if (self.presentedViewController)
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)calendarChooserSelectionDidChange:(EKCalendarChooser *)calendarChooser {
    NSLog(@"chooser change");
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Delete"]) {
        for (id ident in self.calsToDelete) {
            EKCalendar* cal = [self.database calendarWithIdentifier:ident];
            if (cal)
                [self.database removeCalendar:cal commit:YES error:nil];
        }
        self.calsToDelete = nil;
    }
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    } else if (self.presentedViewController)
        [self dismissViewControllerAnimated:YES completion:nil];
}








@end
