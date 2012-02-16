

#import "FlipsideViewController.h"

/* illustrating the rather tricky memory management associated with 
 addObserverForName:...block: under ARC.
 Run the app and flip and flip back.
 If dealloc is never called, you're leaking.
 */

#define which 1 // and try 2 for one answer, and 3 for another

// however, if all you have is individual observers kept in individual ivars,
// the easiest solution is to declare your observer ivar __weak
// this works because the notification center retains the observer until it is removed

// yet another solution, if you *do* have a collection of observers, is to wrap each one
// using NSValue valueWithNonretainedObject: (and extract with nonretainedObjectValue later)

@implementation FlipsideViewController {
    id observer;
}

@synthesize delegate = _delegate;

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (which) {
        case 1: case 2: {
            observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"woohoo" 
                                                                         object:nil queue:nil 
                                                                     usingBlock:^(NSNotification *note) 
            {
                [self description]; // the mere mention of self, explicit or implicit, potentially causes the leak
            }];

            break;
        }
        case 3: {
            __weak FlipsideViewController* wself = self;
            observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"woohoo" 
                                                                         object:nil queue:nil 
                                                                     usingBlock:^(NSNotification *note) 
            {
                FlipsideViewController* sself = wself;
                if (sself) {
                    [sself description];
                }
            }];
            
            break;
        }
    }
}

- (IBAction)done:(id)sender
{
    NSLog(@"observer %@", observer); // prove that observer is valid
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    switch (which) {
        case 1: case 3: break;
        case 2: observer = nil;
    }
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void) dealloc {
    NSLog(@"dealloc");
}

@end
