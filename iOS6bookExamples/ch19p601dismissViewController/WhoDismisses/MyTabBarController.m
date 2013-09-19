

#import "MyTabBarController.h"
#import <objc/objc-runtime.h>


@implementation MyTabBarController

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    NSLog(@"%@", @"tbc dismiss");
    [super dismissViewControllerAnimated:flag completion:completion];
}

// aha, this is how it's really done (undocumented)

- (void) dismissViewControllerWithTransition: (int) t completion:(void (^)(void))completion {
    NSLog(@"tbc %@", @"ha");
    struct objc_super sup = {self, class_getSuperclass([self class])};
    objc_msgSendSuper(&sup, @selector(dismissViewControllerWithTransition:completion:), t, completion);
}


@end
