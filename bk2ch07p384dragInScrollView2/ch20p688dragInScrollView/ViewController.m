

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIImageView *flag;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.flag.translatesAutoresizingMaskIntoConstraints = NO; // tricky-wicky
    
    [self.sv.panGestureRecognizer requireGestureRecognizerToFail:self.swipe]; // *
    
    UIImageView* iv = [[UIImageView alloc]
                       initWithImage:[UIImage imageNamed:@"smiley.png"]];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sv addSubview:iv];
    UIView* sup = self.sv.superview;
    [sup addConstraint:
     [NSLayoutConstraint
      constraintWithItem:iv attribute:NSLayoutAttributeRight
      relatedBy:0
      toItem:sup attribute:NSLayoutAttributeRight
      multiplier:1 constant:-5]];
    [sup addConstraint:
     [NSLayoutConstraint
      constraintWithItem:iv attribute:NSLayoutAttributeTop
      relatedBy:0
      toItem:sup attribute:NSLayoutAttributeTop
      multiplier:1 constant:25]];

}

// delegate of flag's pan gesture recognizer

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)g shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)og {
    return YES; // keep our flag gesture recognizer first
    // trying to avoid weird behavior where sometimes pan gesture fails
}

- (IBAction) swiped: (UISwipeGestureRecognizer*) g {
    
    UIScrollView* sv = self.sv;
    CGPoint p = sv.contentOffset;
    CGRect f = self.flag.frame;
    f.origin = p;
    f.origin.x -= self.flag.bounds.size.width;
    self.flag.frame = f;
    self.flag.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect f2 = self.flag.frame;
        f2.origin.x = p.x;
        self.flag.frame = f2;
        // thanks for the flag, now stop operating altogether
        g.enabled = NO;
        
    }];
}

- (IBAction) dragging: (UIPanGestureRecognizer*) p {
    
    
    UIView* v = p.view;
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: v.superview];
        CGPoint c = v.center;
        c.x += delta.x; c.y += delta.y;
        v.center = c;
        [p setTranslation: CGPointZero inView: v.superview];
    }
    // return; // uncomment if you don't want to autoscroll
    // autoscroll
    if (p.state == UIGestureRecognizerStateChanged) {
        UIScrollView* sv = self.sv;
        CGPoint loc = [p locationInView: sv];
        CGRect f = sv.bounds;
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
