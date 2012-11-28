

#import "RootViewController.h"

@interface RootViewController()
@property (nonatomic, retain) IBOutlet UIDatePicker *dp;
@end

@implementation RootViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateComponents* dc = [[NSDateComponents alloc] init];
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

@end
