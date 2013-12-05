
#import "MySplitViewController.h"

@interface MySplitViewController ()

@end

@implementation MySplitViewController

-(BOOL)prefersStatusBarHidden {
    return YES;
}


-(IBAction)unwind:(UIStoryboardSegue*)seg{
    NSLog(@"split view controller %@", @"unwind");
}


@end
