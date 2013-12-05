

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@end

@implementation ViewController


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)g shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)og {
    
    if ([@"_UISystemGestureGateGestureRecognizer" isEqualToString:NSStringFromClass([og class])]) {
        // NSLog(@"%@", og.class.superclass);
        return NO;

    }
    
    NSLog(@"Should %@ on %p require failure of %@ on %p",
          g.class, g.view, og.class, og.view);
    
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)g shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)og {
    
    if ([@"_UISystemGestureGateGestureRecognizer" isEqualToString:NSStringFromClass([og class])])
        return NO;
    
    NSLog(@"Should %@ on %p be required to fail by %@ on %p",
          g.class, g.view, og.class, og.view);
    
    
    return NO;
}


@end
