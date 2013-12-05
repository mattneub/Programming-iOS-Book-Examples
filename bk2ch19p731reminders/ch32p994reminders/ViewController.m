

#import "ViewController.h"
@import EventKit;

@interface ViewController ()
@property (nonatomic, strong) EKEventStore* database;
@end

@implementation ViewController {
    BOOL _authDone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    EKEntityType type = EKEntityTypeReminder;
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
                     if (granted)
                         self.database = database;
                     else
                         NSLog(@"error: %@", error);
                 }];
            }
        }
    }
}


- (IBAction)doNewReminder:(id)sender {
    if (!self.database)
        return;
    
    EKCalendar* cal = [self.database defaultCalendarForNewReminders];
    if (!cal) {
        NSLog(@"%@", @"failed to find calendar");
        return;
    }
    
    EKReminder* rem = [EKReminder reminderWithEventStore:self.database];
    rem.title = @"Get bread";
    rem.calendar = cal;
    
    // reminder can have due date
    // let's make it today
    NSDate* today = [NSDate date];
    NSCalendar* greg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // day without time means "all day"
    unsigned comps = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    // start date not needed on iOS
    // rem.startDateComponents = [greg components:comps fromDate:today];
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
    // but in iOS 7, background location access must be granted *manually* in Settings
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
