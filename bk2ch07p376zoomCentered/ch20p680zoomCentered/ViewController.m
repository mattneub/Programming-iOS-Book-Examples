

#import "ViewController.h"

@interface ViewController () {
    BOOL _oldBounces;
}
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property BOOL didSetup;
@end

@implementation ViewController

- (void) viewDidLayoutSubviews {
    if (!self.didSetup) {
        self.didSetup = YES;
        // nice to have horizontal centering at startup
        // the scroll view layout goes first, gives us vertical centering
        CGPoint pt = CGPointMake((self.iv.bounds.size.width - self.sv.bounds.size.width)/2.0,0);
        [self.sv setContentOffset:pt animated:NO];
    }
}

#define which

#ifdef which // I like this effect better than without

- (void) scrollViewWillBeginZooming:(UIScrollView *)scrollView
                           withView:(UIView *)view {
    self->_oldBounces = scrollView.bounces;
    scrollView.bounces = NO;
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView
                        withView:(UIView *)view atScale:(float)scale {
    scrollView.bounces = self->_oldBounces;
}

#endif

// image view is zoomable

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:999];
}

// image view is also zoomable by double-tapping

- (IBAction) tapped: (UIGestureRecognizer*) tap {
    UIView* v = tap.view;
    UIScrollView* sv = (UIScrollView*)v.superview;
    if (sv.zoomScale < 1) {
        [sv setZoomScale:1 animated:YES];
        CGPoint pt = CGPointMake((v.bounds.size.width - sv.bounds.size.width)/2.0,0);
        [sv setContentOffset:pt animated:NO];
    }
    else if (sv.zoomScale < sv.maximumZoomScale)
        [sv setZoomScale:sv.maximumZoomScale animated:YES];
    else
        [sv setZoomScale:sv.minimumZoomScale animated:YES];
}



@end
