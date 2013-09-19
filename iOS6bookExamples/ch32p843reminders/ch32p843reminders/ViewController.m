
#import "ViewController.h"
#import <EventKit/EventKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (nonatomic, strong) EKEventStore* database;
@end

@implementation ViewController

/*
 New iOS 6 feature: reminders
 A reminder is really just another kind of calendar event
 */

// run on device

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.database) {
        self.database = [EKEventStore new];
        // no access or authorization involved here
        // however, we are going to need authorization to proceed
        EKAuthorizationStatus status =
        [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
        if (status == EKAuthorizationStatusNotDetermined)
            // completion block cannot be nil!
            [self.database requestAccessToEntityType:EKEntityTypeReminder
                                          completion:^(BOOL granted, NSError *error)
             {
                 NSLog(@"%i", granted);
             }];
    }
}


- (IBAction)doNewReminder:(id)sender {
    EKAuthorizationStatus status =
    [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    if (status == EKAuthorizationStatusDenied || status == EKAuthorizationStatusRestricted) {
        NSLog(@"%@", @"no access");
        return;
    }
    
    EKCalendar* cal = [self.database defaultCalendarForNewReminders];
    if (!cal) {
        NSLog(@"%@", @"failed to find calendar");
        return;
    }
    
    // new iOS 6 class
    // like EKEvent, a reminder is an EKCalendarItem
    // thus it has a calendar and title; it can also have location, recurrence rules, alarms, notes etc.
    // a "calendar" is what the Reminders app calls a "List", but that's just interface
    EKReminder* rem = [EKReminder reminderWithEventStore:self.database];
    rem.title = @"Take a nap";
    rem.calendar = cal;
    
    // reminder can have due date
    // let's make it today
    NSDate* today = [NSDate date];
    NSCalendar* greg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // day without time means "all day"
    unsigned comps = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    rem.dueDateComponents = [greg components:comps fromDate:today];
    
    // let's add an alarm
    // interesting use of location: we can make a location-based alarm
    EKAlarm* alarm = [EKAlarm new];
    EKStructuredLocation *loc = [EKStructuredLocation locationWithTitle:@"Trader Joe's"];
    loc.geoLocation = [[CLLocation alloc] initWithLatitude:34.271848 longitude:-119.247714];
    loc.radius = 10*1000; // metres
    alarm.structuredLocation = loc;
    alarm.proximity = EKAlarmProximityEnter; // "geofence": we alarm when *arriving*
    // if Reminders doesn't have location access, it might ask for it now
    [rem addAlarm:alarm];
    
    NSError* err = nil;
    BOOL ok = [self.database saveReminder:rem commit:YES error:&err];
    if (!ok) {
        NSLog(@"save calendar %@", err.localizedDescription);
        return;
    }
    NSLog(@"%@", @"no error");
}



@end
