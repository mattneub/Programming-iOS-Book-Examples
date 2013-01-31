

#import "RootViewController.h"

@interface RootViewController()
@property (nonatomic, weak) IBOutlet UIDatePicker *dp;
@end

@implementation RootViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSDateComponents* dc = [NSDateComponents new];
    [dc setYear:1954];
    [dc setMonth:1];
    [dc setDay:1];
    NSCalendar* c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate* d = [c dateFromComponents:dc];
    self.dp.minimumDate = d;
    self.dp.date = d;
    [dc setYear:1955];
    d = [c dateFromComponents:dc];
    self.dp.maximumDate = d;

}

- (IBAction)pickerPicked:(id)sender {
    UIDatePicker* dp = sender;
    NSDate* d = [dp date];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:kCFDateFormatterFullStyle];
    [df setDateStyle:kCFDateFormatterFullStyle];
    NSLog(@"%@", [df stringFromDate:d]);

}

@end
