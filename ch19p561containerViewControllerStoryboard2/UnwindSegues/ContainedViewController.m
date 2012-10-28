

#import "ContainedViewController.h"
#import "ContainerViewController.h"

@implementation ContainedViewController

- (void) doPresent: (UIStoryboardSegue*) segue {
    [(ContainerViewController*)self.parentViewController doPresent: segue];
}

- (void) unwind: (id) segue {
    // does nothing, just here because it's expected since this is the designated destination
    // for unwinding
}

- (void) performUnwind: (UIStoryboardSegue*) segue {
    [(ContainerViewController*)self.parentViewController performUnwind: segue];
}


@end
