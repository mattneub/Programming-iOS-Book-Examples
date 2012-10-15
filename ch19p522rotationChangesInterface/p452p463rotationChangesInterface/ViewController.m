

#import "ViewController.h"

@interface ViewController()
@property (nonatomic, strong) UIView* blackRect;
@end

@implementation ViewController

#define which 2 // try "2" for layout-and-constraints way

#if which==1

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

#endif

#if which==2

- (void) insertBlackRect {
    if (self.blackRect)
        return;
    UIView* br = [UIView new];
    br.translatesAutoresizingMaskIntoConstraints = NO;
    br.backgroundColor = [UIColor blackColor];
    [self.view addSubview:br];
    NSArray* cons;
    cons = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-0-[br]-0-|"
            options:0 metrics:nil views:@{@"br":br}];
    [self.view addConstraints:cons];
    cons = [NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|-0-[br]"
            options:0 metrics:nil views:@{@"br":br}];
    [self.view addConstraints:cons];
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:br attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:self.view attribute:NSLayoutAttributeWidth
      multiplier:1.0/3.0 constant:0]];
    self.blackRect = br;
}


-(void)viewWillLayoutSubviews {
    NSLog(@"will layout %i", UIInterfaceOrientationIsPortrait(self.interfaceOrientation));
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        NSLog(@"before %@", self.view.constraints);
        [self insertBlackRect];
        NSLog(@"after %@", self.view.constraints);
    } else {
        NSLog(@"before %@", self.view.constraints);
        [self.blackRect removeFromSuperview];
        self.blackRect = nil;
        NSLog(@"after %@", self.view.constraints);
        /*
         What the log messages show is that when we remove blackRect we are called *again*.
         Evidently, the change in subviews causes our view to perform layout a second time.
         However, this does no harm: self.blackRect is nil so we do nothing,
         and its removal from the superview has eliminated the constraints that affected it.
         */
    }
}

#endif



@end
