

#import "FlipSegue.h"

@implementation FlipSegue

-(void)perform {
    // the sender was set by prepareForSegue
    // in the source view controller
    [self.sender performSelector:@selector(doTransition:) withObject:self];
}

@end
