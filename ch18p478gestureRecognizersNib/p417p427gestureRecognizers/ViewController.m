

#import "ViewController.h"
#import "HorizPanGestureRecognizer.h"
#import "VertPanGestureRecognizer.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIGestureRecognizer* singleTapper;
@property (nonatomic, weak) IBOutlet UIGestureRecognizer* doubleTapper;
@end

@implementation ViewController

// same as #2 of previous example
// gesture recognizers can now be added and configured in nib


- (void) viewDidLoad {

    [self.singleTapper requireGestureRecognizerToFail:self.doubleTapper];

}
 
- (IBAction) singleTap {
    NSLog(@"%@", @"single tap");
}

- (IBAction) doubleTap {
    NSLog(@"%@", @"double tap");
}

- (IBAction) dragging: (UIPanGestureRecognizer*) p {
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
