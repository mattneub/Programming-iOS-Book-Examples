
#import "RootViewController.h"

@implementation RootViewController

- (IBAction)doButton:(id)sender {
    UILocalNotification* ln = [[UILocalNotification alloc] init];
    ln.alertBody = @"Time for another cup of coffee!";
    ln.fireDate = [NSDate dateWithTimeIntervalSinceNow:15];
    ln.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
    [ln release];
}

@end
