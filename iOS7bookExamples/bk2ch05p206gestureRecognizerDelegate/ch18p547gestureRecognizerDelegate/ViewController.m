

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *v;
@property (nonatomic, strong) UILongPressGestureRecognizer* longPresser;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dragging:)];
    UILongPressGestureRecognizer* lp = [[UILongPressGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(longPress:)];
    lp.numberOfTapsRequired = 1;
    [self.v addGestureRecognizer:p];
    [self.v addGestureRecognizer:lp];
    self.longPresser = lp;
    p.delegate = self;

}

- (void) longPress: (UILongPressGestureRecognizer*) lp {
    if (lp.state == UIGestureRecognizerStateBegan) {
        CABasicAnimation* anim =
        [CABasicAnimation animationWithKeyPath: @"transform"];
        anim.toValue =
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        anim.fromValue =
        [NSValue valueWithCATransform3D:CATransform3DIdentity];
        anim.repeatCount = HUGE_VALF;
        anim.autoreverses = YES;
        [lp.view.layer addAnimation:anim forKey:nil];
    }
    if (lp.state == UIGestureRecognizerStateEnded ||
        lp.state == UIGestureRecognizerStateCancelled) {
        [lp.view.layer removeAllAnimations];
    }
}


- (void) dragging: (UIPanGestureRecognizer*) p {
    UIView* vv = p.view;
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: vv.superview];
        CGPoint c = vv.center;
        c.x += delta.x; c.y += delta.y;
        vv.center = c;
        [p setTranslation: CGPointZero inView: vv.superview];
    }
}

- (BOOL) gestureRecognizerShouldBegin: (UIGestureRecognizer*) g {
    // g is the UIPanGestureRecognizer
    NSLog(@"%@", @"begin");
    if (self.longPresser.state == UIGestureRecognizerStatePossible ||
        self.longPresser.state == UIGestureRecognizerStateFailed)
        return NO;
    return YES;
}

- (BOOL)gestureRecognizer: (UIGestureRecognizer*) g1
shouldRecognizeSimultaneouslyWithGestureRecognizer: (UIGestureRecognizer*) g2 {
    NSLog(@"%@", @"sim");
    return YES;
}

/*

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"should %@ %@", gestureRecognizer.class, otherGestureRecognizer.class);
    return NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"shouldbe %@ %@", gestureRecognizer.class, otherGestureRecognizer.class);
    return NO;

}
 
 */
 


@end
