

#import "RootViewController.h"


@implementation RootViewController


#pragma mark - View lifecycle

- (void) loadView { // the green background and "hello world" prove that out view controller's view is present
    UIView* v = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    v.backgroundColor = [UIColor greenColor];
    UILabel* label = [[UILabel alloc] init];
    label.text = @"Hello, World!";
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds));
    label.autoresizingMask = (
                              UIViewAutoresizingFlexibleTopMargin |
                              UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleBottomMargin |
                              UIViewAutoresizingFlexibleRightMargin
                              );
    [v addSubview:label];
    self.view = v;
    [label release];
    [v release];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; // rotation proves that the view controller is really doing something useful
}

@end
