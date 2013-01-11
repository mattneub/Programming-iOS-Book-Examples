

#import "MyAmazingSegue.h"

@implementation MyAmazingSegue

-(void)perform {
    UIViewController* vc1 = self.sourceViewController;
    UIViewController* vc2 = vc1.presentingViewController;
    [vc1 dismissViewControllerAnimated:YES completion:^{
        [(UINavigationController*)vc2 popToRootViewControllerAnimated:YES];
    }];
}

@end
