
#import "MyUnwindSegue.h"

@implementation MyUnwindSegue

-(void)perform {
    [((UIViewController*)self.destinationViewController).navigationController performSelector:@selector(unwindThisPuppy:) withObject:self];
}

@end
