
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

@implementation ViewController {
    __weak IBOutlet UIView *v1;
    __weak IBOutlet UIView *v2;
}

-(void)viewDidLoad {
    UIView* sup = self.view;
    v1.translatesAutoresizingMaskIntoConstraints = NO;
    v2.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* d = NSDictionaryOfVariableBindings(sup, v1, v2);
    [sup addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"|-[v1]-(40)-[v2(==v1)]-|"
      options:0 metrics:0 views:d]];
    [sup addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-[v1]-|"
      options:0 metrics:0 views:d]];
    [sup addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-[v2]-|"
      options:0 metrics:0 views:d]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSLayoutConstraint reportAmbiguity:nil];
// or pause at breakpoint and say po [[UIWindow keyWindow] _autolayoutTrace]
}

@end
