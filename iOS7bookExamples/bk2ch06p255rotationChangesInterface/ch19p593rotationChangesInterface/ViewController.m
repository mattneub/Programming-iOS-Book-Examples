

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIView* blackRect;
@property (nonatomic, strong) NSArray* blackRectConstraintsOnscreen;
@property (nonatomic, strong) NSArray* blackRectConstraintsOffscreen;
@end

@implementation ViewController

#define which 2

#if which == 1

- (UIView*) blackRect {
    if (!self->_blackRect) {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            return nil;
        CGRect f = self.view.bounds;
        f.size.width /= 3.0;
        f.origin.x = -f.size.width;
        UIView* br = [[UIView alloc] initWithFrame:f];
        br.backgroundColor = [UIColor blackColor];
        self.blackRect = br;
    }
    return self->_blackRect;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)io
                                        duration:(NSTimeInterval)duration {
    UIView* v = self.blackRect;
    if (UIInterfaceOrientationIsLandscape(io)) {
        if (!v.superview) {
            //            NSLog(@"add");
            [self.view addSubview:v];
            CGRect f = v.frame;
            f.origin.x = 0;
            v.frame = f;
        }
    } else {
        if (v.superview) {
            //            NSLog(@"remove");
            CGRect f = v.frame;
            f.origin.x -= f.size.width;
            v.frame = f;
        }
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)io
                                 duration:(NSTimeInterval)duration {
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)io {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.blackRect removeFromSuperview];
}

#elif which == 2

-(void)viewDidLoad {
    UIView* br = [UIView new];
    br.translatesAutoresizingMaskIntoConstraints = NO;
    br.backgroundColor = [UIColor blackColor];
    [self.view addSubview:br];
    // not needed if we're already doing autolayout
    // [self.view setNeedsUpdateConstraints];
    
    // "b.r. is pinned to top and bottom of superview"
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[br]|"
      options:0 metrics:nil views:@{@"br":br}]];
    
    // "b.r. is 1/3 the width of superview"
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:br attribute:NSLayoutAttributeWidth
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeWidth
      multiplier:1.0/3.0 constant:0]];
    
    // "onscreen, b.r.'s left is pinned to superview's left"
    NSArray* marrOn =
    [NSLayoutConstraint
     constraintsWithVisualFormat:@"H:|[br]"
     options:0 metrics:nil views:@{@"br":br}];
    
    // "offscreen, b.r.'s right is pinned to superview's left"
    NSArray* marrOff = @[
                         [NSLayoutConstraint
                          constraintWithItem:br attribute:NSLayoutAttributeRight
                          relatedBy:NSLayoutRelationEqual
                          toItem:self.view attribute:NSLayoutAttributeLeft
                          multiplier:1 constant:0]
                         ];
    
    self.blackRectConstraintsOnscreen = marrOn;
    self.blackRectConstraintsOffscreen = marrOff;
}

-(void)updateViewConstraints {
    NSLog(@"updateviewconstraints %ld", (long)self.interfaceOrientation);
    [self.view removeConstraints:self.blackRectConstraintsOnscreen];
    [self.view removeConstraints:self.blackRectConstraintsOffscreen];
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        [self.view addConstraints:self.blackRectConstraintsOnscreen];
    else
        [self.view addConstraints:self.blackRectConstraintsOffscreen];
    [super updateViewConstraints];
}



#endif

@end
