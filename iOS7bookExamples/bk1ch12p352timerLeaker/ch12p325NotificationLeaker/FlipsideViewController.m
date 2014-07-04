
/*
Run the app and flip and flip back.
If dealloc is never called, you're leaking.
*/

#import "FlipsideViewController.h"

#define WHICH 0 // 0 shows the problem; solutions are 1, 2, 3


#if WHICH==0 //==================

// THE PROBLEM

@interface FlipsideViewController ()
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation FlipsideViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"starting %d", WHICH);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dummy:) userInfo:nil repeats:YES];
    self.timer.tolerance = 0.1;
}

- (void) dummy: (id) dummy {
    NSLog(@"timer fired");
}

- (void) dealloc {
    // dealloc is never called, we are leaking
    NSLog(@"%@", @"dealloc");
    // timer is never invalidated, it keeps running
    [self->_timer invalidate];
}

#elif WHICH==1 //=================

// SOLUTION 1: invalidate the timer somewhere else

@interface FlipsideViewController ()
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation FlipsideViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"starting %d", WHICH);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dummy:) userInfo:nil repeats:YES];
    self.timer.tolerance = 0.1;
}

- (void) dummy: (id) dummy {
    NSLog(@"timer fired");
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self->_timer invalidate];
}

- (void) dealloc {
    NSLog(@"%@", @"dealloc");
}

#elif WHICH==2 //=================

// SOLUTION 2: Use GCD and a block instead of a timer, and stop the block outside dealloc

@interface FlipsideViewController ()
@end

@implementation FlipsideViewController {
    dispatch_source_t _timer; // ARC will manage this pseudo-object
}

- (void)doStart:(id)sender {
    NSLog(@"starting %d", WHICH);
    self->_timer = dispatch_source_create(
                                          DISPATCH_SOURCE_TYPE_TIMER,0,0,dispatch_get_main_queue());
    dispatch_source_set_timer(
                              self->_timer, dispatch_walltime(nil, 0),
                              1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC
                              );
    dispatch_source_set_event_handler(self->_timer, ^{
        [self dummy:nil]; // retain cycle
    });
    dispatch_resume(self->_timer);
}

- (IBAction)doStop:(id)sender {
    self->_timer = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self doStart:nil];
}

- (void) dummy: (id) dummy {
    NSLog(@"timer fired");
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self doStop:nil]; // if this is commented out, we leak and the timer doesn't stop
}

- (void) dealloc {
    NSLog(@"%@", @"dealloc");
}

#elif WHICH==3 //=================

// SOLUTION 3: weak-strong dance; no retain cycle, we can stop the timer in dealloc

@interface FlipsideViewController ()
@end

@implementation FlipsideViewController {
    dispatch_source_t _timer; // ARC will manage this pseudo-object
}

- (void)doStart:(id)sender {
    NSLog(@"starting %d", WHICH);
    self->_timer = dispatch_source_create(
                                          DISPATCH_SOURCE_TYPE_TIMER,0,0,dispatch_get_main_queue());
    dispatch_source_set_timer(
                              self->_timer, dispatch_walltime(nil, 0),
                              1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC
                              );
    __weak id wself = self;
    dispatch_source_set_event_handler(self->_timer, ^{
        FlipsideViewController* sself = wself;
        if (sself) {
            [sself dummy:nil]; // prevent retain cycle
        }
    });
    dispatch_resume(self->_timer);
}

- (void)doStop:(id)sender {
    self->_timer = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self doStart:nil];
}

- (void) dummy: (id) dummy {
    NSLog(@"timer fired");
}

- (void) dealloc {
    [self doStop:nil];
    NSLog(@"%@", @"dealloc");
}



#endif //====================


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
