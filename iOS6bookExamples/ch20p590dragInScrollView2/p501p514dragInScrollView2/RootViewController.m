

#import "RootViewController.h"

@interface RootViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView* sv;
@end

@implementation RootViewController 

// variant on the preceding example
// at the outset, there is no flag
// the user can summon the flag with a swipe to the right
// demonstrates that we can now interact with the scroll view's built-in gesture recognizers

-(void) viewDidLoad {
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
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    [sv addGestureRecognizer:swipe];
    
    // but a swipe will never be recognized if panning is possible, so put the tests in order
    // first see if it's a right-swipe, then allow user to drag contents
    [sv.panGestureRecognizer requireGestureRecognizerToFail:swipe];
    
}

- (void) swiped: (UISwipeGestureRecognizer*) g {
    if (g.state == UIGestureRecognizerStateEnded || g.state == UIGestureRecognizerStateCancelled) {
        UIImageView* flag = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"redflag.png"]];
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] 
                                       initWithTarget:self
                                       action:@selector(dragging:)];
        [flag addGestureRecognizer:pan];
        flag.userInteractionEnabled = YES;
        
        UIScrollView* sv = self.sv;
        CGPoint p = sv.contentOffset;
        CGRect f = flag.frame;
        f.origin = p;
        f.origin.x -= flag.bounds.size.width;
        flag.frame = f;
        
        [sv addSubview: flag];
        // thanks for the flag, now stop operating altogether
        g.enabled = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            CGRect f = flag.frame;
            f.origin.x = p.x;
            flag.frame = f;
        }];
    }
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
