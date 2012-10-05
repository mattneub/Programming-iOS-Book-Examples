
// demonstrates the memory management problem with timers!
// the timer retains the target
// the Leaks tool does not detect this as a problem (naturally enough)

// so timer management is tricky: you have to invalidate it somehow in order to release yourself

// omitted from the book, but we really need an explicit note on this point


#import "VC2.h"

@implementation VC2 {
    NSTimer* timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"VC2";
    self->timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dummy:) userInfo:nil repeats:YES];
}

- (void) dummy: (id) dummy {
    NSLog(@"dummy");
}

// this is the solution!
// comment this out and you'll discover that you've created a memory leak:
// this VC2 instance and everything depending on it is never deallocated

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        [self->timer invalidate];
    }
}

- (void)dealloc {
    [self->timer invalidate]; // this will probably do nothing;
    // dealloc wouldn't even be called if the timer were valid
    NSLog(@"dealloc");
}

@end
