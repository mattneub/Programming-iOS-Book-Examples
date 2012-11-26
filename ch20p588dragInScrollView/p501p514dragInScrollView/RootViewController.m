

#import "RootViewController.h"

@interface RootViewController()
@property (nonatomic, strong) UIScrollView* sv;
@end

@implementation RootViewController


-(void) viewDidLoad {
    [super viewDidLoad];
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.sv = sv;
    [self.view addSubview:sv];
    
    UIImageView* imv = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"map.jpg"]];
    [sv addSubview:imv];
    sv.contentSize = imv.bounds.size;
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
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    
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
                [self performSelector:@selector(dragging:) withObject:p afterDelay:0.2];
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
                [self performSelector:@selector(dragging:) withObject:p afterDelay:0.2];
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
                [self performSelector:@selector(dragging:) withObject:p afterDelay:0.2];
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
                [self performSelector:@selector(dragging:) withObject:p afterDelay:0.2];
            }
        }
    }
}


@end
