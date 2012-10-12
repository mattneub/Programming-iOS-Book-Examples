
#import "ViewController.h"

@interface NSLayoutConstraint (checkambig)
+ (void) reportAmbiguity:(UIView*) v;
@end

@implementation NSLayoutConstraint (checkambig)

// here's a way to hunt for ambiguous layout (remember not to run in shipping code)
+ (void) reportAmbiguity:(UIView*) v {
    if (nil == v)
        v = [[UIApplication sharedApplication] keyWindow];
    for (UIView* vv in v.subviews) {
        NSLog(@"%@ %i", vv, vv.hasAmbiguousLayout);
        if (vv.subviews.count)
            [self reportAmbiguity:vv];
    }
}

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSLayoutConstraint reportAmbiguity:nil];
// or pause at breakpoint and say po [[UIWindow keyWindow] _autolayoutTrace]
}

@end
