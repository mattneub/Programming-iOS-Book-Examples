
#import "GestureRecognizersAppDelegate.h"
#import "HorizPanGestureRecognizer.h"
#import "VertPanGestureRecognizer.h"

@implementation GestureRecognizersAppDelegate


@synthesize window=_window;
@synthesize view;

#define which 1 // try also 2

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // view that can be single-tapped, double-tapped, or dragged
    
    UITapGestureRecognizer* t2 = [[UITapGestureRecognizer alloc] 
                                  initWithTarget:self 
                                  action:@selector(doubleTap)];
    t2.numberOfTapsRequired = 2;
    [view addGestureRecognizer:t2];
    
    UITapGestureRecognizer* t1 = [[UITapGestureRecognizer alloc] 
                                  initWithTarget:self 
                                  action:@selector(singleTap)];
    [t1 requireGestureRecognizerToFail:t2];
    [view addGestureRecognizer:t1];
    [t1 release];
    [t2 release];
    
    switch (which) {
        case 1:
        {
            UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc] 
                                         initWithTarget:self 
                                         action:@selector(dragging:)];
            [view addGestureRecognizer:p];
            [p release];

            break;
        }
        case 2:
        {
            // p 418, view can be dragged only horizontally or vertically
            UIPanGestureRecognizer* p = [[HorizPanGestureRecognizer alloc] 
                                         initWithTarget:self 
                                         action:@selector(dragging:)];
            [view addGestureRecognizer:p];
            [p release];
            UIPanGestureRecognizer* p2 = [[VertPanGestureRecognizer alloc] 
                                         initWithTarget:self 
                                         action:@selector(dragging:)];
            [view addGestureRecognizer:p2];
            [p2 release];

            break;
        }
            
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) singleTap {
    NSLog(@"%@", @"single tap");
}

- (void) doubleTap {
    NSLog(@"%@", @"double tap");
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
}

- (void)dealloc
{
    [_window release];
    [view release];
    [super dealloc];
}

@end
