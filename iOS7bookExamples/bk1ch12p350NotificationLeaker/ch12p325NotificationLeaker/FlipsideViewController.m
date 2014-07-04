
/*
Run the app and flip and flip back.
If dealloc is never called, you're leaking.
*/

#import "FlipsideViewController.h"

#define WHICH 0 // 0 shows the problem; solutions are 1, 2, 3 (and 4, but I don't advise it)


#if WHICH==0 //==================

// THE PROBLEM

@interface FlipsideViewController ()
@property (nonatomic, strong) id observer;
@end

@implementation FlipsideViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"register %d", WHICH);
    self.observer = [[NSNotificationCenter defaultCenter]
                     addObserverForName:@"woohoo"
                     object:nil queue:nil
                     usingBlock:^(NSNotification *note)
                     {
                         [self description]; // potential leak
                     }];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@", @"unregister");
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

- (void) dealloc {
    // dealloc is never called, we are leaking
    NSLog(@"%@", @"dealloc");
}

#elif WHICH==1 //=================

// SOLUTION 1: weak ivar
// still can't remove observer in dealloc...
// because we have a retain cycle until we remove the observer!
// but at least removing the observer breaks the retain cycle and prevents the leak

@interface FlipsideViewController ()
@property (nonatomic, weak) id observer; // <=====
@end

@implementation FlipsideViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"register %d", WHICH);
    self.observer = [[NSNotificationCenter defaultCenter]
                     addObserverForName:@"woohoo"
                     object:nil queue:nil
                     usingBlock:^(NSNotification *note)
                     {
                         [self description]; // potential leak
                     }];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@", @"unregister");
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

- (void) dealloc {
    NSLog(@"%@", @"dealloc");
}

#elif WHICH==2 //=================

// SOLUTION 2: explicit release of observer
// still can't remove observer in dealloc...
// because we have a retain cycle until we remove the observer!
// but at least removing the observer breaks the retain cycle and prevents the leak

@interface FlipsideViewController ()
@property (nonatomic, strong) id observer;
@end

@implementation FlipsideViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"register %d", WHICH);
    self.observer = [[NSNotificationCenter defaultCenter]
                     addObserverForName:@"woohoo"
                     object:nil queue:nil
                     usingBlock:^(NSNotification *note)
                     {
                         [self description]; // potential leak
                     }];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@", @"unregister");
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    self.observer = nil; // <=======
}

- (void) dealloc {
    NSLog(@"%@", @"dealloc");
}

#elif WHICH==3 //=================

// SOLUTION 3: weak-strong dance

@interface FlipsideViewController ()
@property (nonatomic, strong) id observer;
@end

@implementation FlipsideViewController  {
    NSString* myIvar;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"register %d", WHICH);
    __weak id weakself = self; // <====
    self.observer = [[NSNotificationCenter defaultCenter]
                     addObserverForName:@"woohoo"
                     object:nil queue:nil
                     usingBlock:^(NSNotification *note)
                     {
                         FlipsideViewController* sself = weakself; // <===
                         if (sself) {                              // <===
                             [sself description]; // no leak - be careful not to mention self!
                             // do not use NSAssert!
                             // NSAssert(1, @"dummy assertion");
                             // do not use ivar names!
                             // myIvar = @"Testing"; // fortunately, compiler warns on this one
                         }
                     }];
}

- (void) dealloc {
    NSLog(@"%@", @"dealloc");
    // this solution has a big advantage: we can unregister in dealloc!
    NSLog(@"%@", @"unregister");
    [[NSNotificationCenter defaultCenter] removeObserver:self->_observer];
}

#elif WHICH==4 //=================

// SOLUTION 4: unregister in the block
// obviously this only works if you expect the block to be called exactly once
// but I don't like this approach - if the notification is never posted, we never unregister...
// and we are never released, so we leak; it's an unnecessary gamble

@interface FlipsideViewController ()
@end

@implementation FlipsideViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"register %d", WHICH);
    __weak __block id observer = [[NSNotificationCenter defaultCenter]
                     addObserverForName:@"woohoo"
                     object:nil queue:nil
                     usingBlock:^(NSNotification *note)
                     {
                         [self description]; // no leak - be careful not to mention self!
                         NSLog(@"%@", @"unregister");
                         [[NSNotificationCenter defaultCenter] removeObserver:observer];
                     }];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // return // uncomment this line so the notification is never posted, and you'll see we leak
    NSLog(@"%@", @"posting");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"woohoo" object:nil];
}

- (void) dealloc {
    NSLog(@"%@", @"dealloc");
}



#endif //====================


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
