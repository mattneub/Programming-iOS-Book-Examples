

#import "FlipsideViewController.h"

/* illustrating the rather tricky memory management associated with 
 addObserverForName:...block: under ARC.
 Run the app and flip and flip back.
 If dealloc is never called, you're leaking.
 */

#define which 1 // and try 2 for one solution, and 3 for another
// new in iOS 6, try 4: we can now collect weak pointers!

// however, if all you have is individual observers kept in individual ivars,
// the easiest solution is to declare your observer property weak
// this works because the notification center retains the observer until it is removed

// yet another solution, if you *do* have a collection of observers, is to wrap each one
// using NSValue valueWithNonretainedObject: (and extract with nonretainedObjectValue later)

// but that trick is now superseded by the use of NSPointerArray shown as 4 below

@interface FlipsideViewController ()
// to solve case 1, change "strong" to "weak" here
// for case 2 and 3, leave it at "strong" to see how we can break the retain cycle
@property (nonatomic, strong) id observer;

@property (nonatomic, strong) NSHashTable* set;

@end


@implementation FlipsideViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (which) {
        case 1:
        case 2: {
            self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"woohoo"
                                                                         object:nil queue:nil 
                                                                     usingBlock:^(NSNotification *note) 
            {
                [self description]; // the mere mention of self, explicit or implicit, potentially causes the leak
            }];

            break;
        }
        case 3: { // weak-strong dance prevents retain cycle up front
            __weak FlipsideViewController* wself = self;
            self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"woohoo"
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
        case 4: {
            // imagine we have many of these observers
            // collect them into a weak mutable set (hash table)
            self.set = [NSHashTable weakObjectsHashTable];
            [self.set addObject:
             ([[NSNotificationCenter defaultCenter]
               addObserverForName:@"woohoo"
               object:nil queue:nil
               usingBlock:^(NSNotification *note)
               {
                   [self description];
               }])];
            [self.set addObject:
             ([[NSNotificationCenter defaultCenter]
               addObserverForName:@"woohoo"
               object:nil queue:nil
               usingBlock:^(NSNotification *note)
               {
                   [self description];
               }])];
        }
    }
}

- (IBAction)done:(id)sender
{
    switch (which) {
        case 1: {
            NSLog(@"observer %@", self.observer); // prove that observer is valid
            [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
            break;
        };
        case 2: {
            NSLog(@"observer %@", self.observer); // prove that observer is valid
            [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
            self.observer = nil; // extra step if property is strong reference
            break;
        }
        case 4: {
            // remove all observers
            for (id obj in self.set) {
                NSLog(@"%@", obj); // prove that observer is valid
                [[NSNotificationCenter defaultCenter] removeObserver:obj];
            }
            // that's all! self.set was not retaining those observers
            break;
        }
        case 3: break;
    }
    [self.delegate flipsideViewControllerDidFinish:self];
}

// note that case 3 has the remarkable property that you can unregister in dealloc itself

- (void) dealloc {
    NSLog(@"dealloc");
    switch (which) {
        case 4: break;
        case 1: break;
        case 2: break;
        case 3: {
            NSLog(@"observer %@", self.observer); // prove that observer is valid
            [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
        }
    }

}

@end
