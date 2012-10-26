
#import "MyPageViewController.h"
#import "Pep.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

-(id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style
       navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation
                     options:(NSDictionary *)options
{
    self = [super initWithTransitionStyle:style
                    navigationOrientation:navigationOrientation
                                  options:options];
    if (self) {
        NSLog(@"pvc init");
        self.restorationIdentifier = @"pvc"; //
    }
    return self;
}

// just as with the root view controller, if we want restoration to work its way down to our child
// we must have a restoration id, and...
// we must encode a reference to our child

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"pvc encode");
    [coder encodeObject:self.viewControllers[0] forKey:@"pvcchild"];
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"pvc decode");
    [super decodeRestorableStateWithCoder:coder];
}



@end
