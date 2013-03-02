
#import "MySplitViewController.h"

@interface MySplitViewController ()

@end

@implementation MySplitViewController

-(IBAction)unwind:(UIStoryboardSegue*)seg{
    NSLog(@"split view controller %@", @"unwind");
}


@end
