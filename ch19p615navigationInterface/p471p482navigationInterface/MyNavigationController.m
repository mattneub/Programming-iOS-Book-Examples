

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

/* Again, need to subclass if you want to avoid default rotation behavior.
 Children are not relevant; rotation is governed by us, and default is all.
 */

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
