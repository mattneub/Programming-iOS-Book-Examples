

#import "RootViewController.h"

@implementation RootViewController 

// variant on the preceding example: not in the book, uses a feature new in iOS 5
// at the outset, there is no flag
// the user can summon the flag with a swipe to the right
// demonstrates that we can now interact with the scroll view's built-in gesture recognizers

-(void) loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = sv;
    
    UIImageView* imv = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"map.jpg"]];
    [sv addSubview:imv];
    sv.contentSize = imv.bounds.size;
    
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
        
        UIScrollView* sv = (UIScrollView*)self.view;
        CGPoint p = sv.contentOffset;
        CGRect f = flag.frame;
        f.origin = p;
        f.origin.x -= flag.bounds.size.width;
        flag.frame = f;
        
        [sv addSubview: flag];
        
        [UIView beginAnimations:nil context:NULL];
        f.origin.x = p.x;
        flag.frame = f;
        [UIView commitAnimations];
        
        // thanks for the flag, now stop operating altogether
        g.enabled = NO;
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
        UIScrollView* sv = (UIScrollView*)self.view;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
