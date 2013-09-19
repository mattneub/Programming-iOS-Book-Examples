

#import "FlipsideViewController.h"

@interface FlipsideViewController ()
@property (nonatomic, copy) NSString* outputString;
@end

@implementation FlipsideViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"flipside view controller preparing for segue %@", segue.identifier);
}

-(void)dealloc {
    NSLog(@"dealloc flipsideviewcontroller");
}

@end
