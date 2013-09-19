

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIImageView *flag;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.flag.translatesAutoresizingMaskIntoConstraints = NO; // tricky-wicky
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
