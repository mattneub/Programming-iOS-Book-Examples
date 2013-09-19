

#import "ElaborateViewController.h"

@interface ElaborateViewController ()

@end

@implementation ElaborateViewController

- (IBAction)doCancel:(id)sender {
    [self.activity activityDidFinish:NO];

}
- (IBAction)doDone:(id)sender {
    [self.activity activityDidFinish:YES];

}

-(void)dealloc {
    NSLog(@"%@", @"elaborate view controller dealloc");
}

@end
