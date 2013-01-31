

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dp;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // self.dp.minuteInterval = 2;
}

- (IBAction)doStart:(id)sender {
    NSTimeInterval t = self.dp.countDownDuration;
    NSLog(@"%f", t);
    NSDate* d = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
    NSCalendar* c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [c setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0]]; // normalize
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents* dc = [c components:units fromDate:d];
    NSLog(@"Pretend I'm counting from %i hr, %i min", [dc hour], [dc minute]);
}

@end
