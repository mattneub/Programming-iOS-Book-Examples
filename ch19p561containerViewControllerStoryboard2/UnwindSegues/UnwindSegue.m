

#import "UnwindSegue.h"

@implementation UnwindSegue

-(void) perform {
    [self.destinationViewController performSelector:@selector(performUnwind:) withObject:self];
}

@end
