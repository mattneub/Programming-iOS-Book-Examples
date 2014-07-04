

#import "ViewController.h"
#import "HorizPanGestureRecognizer.h"
#import "VertPanGestureRecognizer.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // view that can be single-tapped, double-tapped, or dragged
    
    UITapGestureRecognizer* t2 = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(doubleTap)];
    t2.numberOfTapsRequired = 2;
    [self.v addGestureRecognizer:t2];
    
    UITapGestureRecognizer* t1 = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(singleTap)];
    [t1 requireGestureRecognizerToFail:t2];
    [self.v addGestureRecognizer:t1];
    
#define which 2
#if which == 1
    
    UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dragging:)];
    [self.v addGestureRecognizer:p];
    
#elif which == 2
    
    // p 418, view can be dragged only horizontally or vertically
    UIPanGestureRecognizer* p = [[HorizPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dragging:)];
    [self.v addGestureRecognizer:p];
    
    UIPanGestureRecognizer* p2 = [[VertPanGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(dragging:)];
    [self.v addGestureRecognizer:p2];
    
#endif

}

- (void) singleTap {
    NSLog(@"%@", @"single tap");
}

- (void) doubleTap {
    NSLog(@"%@", @"double tap");
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


@end
