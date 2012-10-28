

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyView.h"

@interface RootViewController () <UIScrollViewDelegate>
@end

@implementation RootViewController

- (void)loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = sv;
    
    CGRect f = CGRectMake(0,0,self.view.bounds.size.width,940);
    MyView* content = [[MyView alloc] initWithFrame:f];
    content.tag = 999;
    [self.view addSubview:content];
    [sv setContentSize: f.size];
    sv.minimumZoomScale = 1.0;
    sv.maximumZoomScale = 2.0;
    sv.delegate = self;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:999];
}

// this is another way to accomplish the same sort of thing: after the zoom ends, we
// "crisp up" its drawing by adjusting its internal drawing scale
// however, this isn't a universally viable approach, because we've vastly increased
// the number of pixels to be held in memory, which might cause us to run out of memory
// see WWDC 2011 video

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
        view.contentScaleFactor = scale * [UIScreen mainScreen].scale;
}


@end
