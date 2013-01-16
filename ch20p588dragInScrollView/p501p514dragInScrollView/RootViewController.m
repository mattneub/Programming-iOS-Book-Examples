

#import "RootViewController.h"

@interface RootViewController()
@property (nonatomic, strong) UIScrollView* sv;
@end

@implementation RootViewController


-(void) viewDidLoad {
    // great opportunity to illustrate setting up a scroll view by constraints alone
    
    [super viewDidLoad];
    UIScrollView* sv = [UIScrollView new];
    self.sv = sv;
    [self.view addSubview:sv];
    sv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sv]|"
                                             options:0 metrics:nil views:@{@"sv":sv}]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sv]|"
                                             options:0 metrics:nil views:@{@"sv":sv}]];
    
    UIImageView* imv = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"map.jpg"]];
    [sv addSubview:imv];
    imv.translatesAutoresizingMaskIntoConstraints = NO;
    // constraints here mean "content view is the size of the image view"
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imv]|"
                                             options:0 metrics:nil views:@{@"imv":imv}]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imv]|"
                                             options:0 metrics:nil views:@{@"imv":imv}]];

    
    UIImageView* flag = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"redflag.png"]];
    [sv addSubview: flag];
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] 
                                   initWithTarget:self
                                   action:@selector(dragging:)];
    [flag addGestureRecognizer:pan];
    flag.userInteractionEnabled = YES;
    
    /*
     Illustrate new scroll view feature available thanks to constraints:
     it's easy to make a scroll view subview whose position doesn't scroll -
     just constrain it to something *outside* the scroll view
     */
    
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smiley.png"]];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    [sv addSubview:iv];
    UIView* sup = sv.superview;
    [sup addConstraint:
     [NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:sup attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    [sup addConstraint:
     [NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sup attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
}

- (void) dragging: (UIPanGestureRecognizer*) p {
    UIView* v = p.view;
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: v.superview];
        CGPoint c = v.center;
        c.x += delta.x; c.y += delta.y;
        v.center = c;
        [p setTranslation: CGPointZero inView: v.superview];
    }
    // autoscroll
    if (p.state == UIGestureRecognizerStateChanged) {
        CGPoint loc = [p locationInView:self.view.superview];
        CGRect f = self.view.frame;
        UIScrollView* sv = self.sv;
        CGPoint off = sv.contentOffset;
        CGSize sz = sv.contentSize;
        CGPoint c = v.center;
        // to the right
        if (loc.x > CGRectGetMaxX(f) - 30) {
            CGFloat margin = sz.width - CGRectGetMaxX(sv.bounds);
            if (margin > 6) {
                off.x += 5;
                sv.contentOffset = off;
                c.x += 5;
                v.center = c;
                [self keepDragging:p];
            }
        }
        // to the left
        if (loc.x < f.origin.x + 30) {
            CGFloat margin = off.x;
            if (margin > 6) {
                off.x -= 5;
                sv.contentOffset = off;
                c.x -= 5;
                v.center = c;
                [self keepDragging:p];
            }
        }
        // to the bottom
        if (loc.y > CGRectGetMaxY(f) - 30) {
            CGFloat margin = sz.height - CGRectGetMaxY(sv.bounds);
            if (margin > 6) {
                off.y += 5;
                sv.contentOffset = off;
                c.y += 5;
                v.center = c;
                [self keepDragging:p];
            }
        }
        // to the top
        if (loc.y < f.origin.y + 30) {
            CGFloat margin = off.y;
            if (margin > 6) {
                off.y -= 5;
                sv.contentOffset = off;
                c.y -= 5;
                v.center = c;
                [self keepDragging:p];
            }
        }
    }
}

- (void) keepDragging: (UIPanGestureRecognizer*) p {
    // the delay here, combined with the change in offset, determines the speed of autoscrolling
    float delay = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dragging: p];
    });
}


@end
