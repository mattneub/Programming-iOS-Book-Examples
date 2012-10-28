

#import "PresentSegue.h"

@implementation PresentSegue

-(void)perform {
    [self.sourceViewController performSelector:@selector(doPresent:) withObject:self];
}

@end
