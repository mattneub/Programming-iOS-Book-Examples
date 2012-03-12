

#import "SegueNoAnimation.h"

@implementation SegueNoAnimation

- (void) perform {
    // the storyboard doesn't provide "no animation" as an option for the modal segue
    // so we are compelled to use a custom segue and perform the presentation ourselves
    [self.sourceViewController presentViewController:self.destinationViewController 
                                            animated:NO completion:nil];
}

@end
