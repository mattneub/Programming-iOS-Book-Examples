

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

#define which 1

#if which == 1

- (void) loadView {
    UIView* v = [UIView new];
    v.backgroundColor = [UIColor greenColor];
    self.view = v;
    UILabel* label = [UILabel new];
    [v addSubview:label];
    label.text = @"Hello, World!";
    label.autoresizingMask = (
                              UIViewAutoresizingFlexibleTopMargin |
                              UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleBottomMargin |
                              UIViewAutoresizingFlexibleRightMargin
                              );
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(v.bounds),
                               CGRectGetMidY(v.bounds));
    label.frame = CGRectIntegral(label.frame);
}

#elif which == 2

- (void) loadView {
    UIView* v = [UIView new];
    v.backgroundColor = [UIColor greenColor];
    self.view = v;
    UILabel* label = [UILabel new];
    [v addSubview:label];
    label.text = @"Hello, World!";
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:label attribute:NSLayoutAttributeCenterX
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeCenterX
      multiplier:1 constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:label attribute:NSLayoutAttributeCenterY
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeCenterY
      multiplier:1 constant:0]];
}

#elif which == 3

- (void) loadView {
    UIView* v = [UIView new];
    self.view = v;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UIView* v = self.view;
    v.backgroundColor = [UIColor greenColor];
    UILabel* label = [UILabel new];
    [v addSubview:label];
    label.text = @"Hello, World!";
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:label attribute:NSLayoutAttributeCenterX
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeCenterX
      multiplier:1 constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:label attribute:NSLayoutAttributeCenterY
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeCenterY
      multiplier:1 constant:0]];
}

#elif which == 4

// no loadView, no other means of getting the view...
// so a generic view is created for us

- (void) viewDidLoad {
    [super viewDidLoad];
    UIView* v = self.view;
    v.backgroundColor = [UIColor greenColor];
    UILabel* label = [UILabel new];
    [v addSubview:label];
    label.text = @"Hello, World!";
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:label attribute:NSLayoutAttributeCenterX
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeCenterX
      multiplier:1 constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:label attribute:NSLayoutAttributeCenterY
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeCenterY
      multiplier:1 constant:0]];
}

#endif



@end
