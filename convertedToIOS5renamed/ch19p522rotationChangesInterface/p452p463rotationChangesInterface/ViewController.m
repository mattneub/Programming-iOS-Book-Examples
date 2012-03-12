

#import "ViewController.h"

@interface ViewController()
@property (nonatomic, strong) UIView* blackRect;
@end

@implementation ViewController
@synthesize blackRect = _blackRect;

- (UIView*) blackRect {
    if (!self->_blackRect) {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            return nil;
        CGRect f = self.view.bounds;
        f.size.width /= 3.0;
        f.origin.x = -f.size.width;
        UIView* br = [[UIView alloc] initWithFrame:f];
        br.backgroundColor = [UIColor blackColor];
        self.blackRect = br;
    }
    return self->_blackRect;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)io 
                                        duration:(NSTimeInterval)duration {
    UIView* v = self.blackRect;
    if (UIInterfaceOrientationIsLandscape(io)) {
        if (!v.superview) {
//            NSLog(@"add");
            [self.view addSubview:v];
            CGRect f = v.frame;
            f.origin.x = 0;
            v.frame = f;
        }
    } else {
        if (v.superview) {
//            NSLog(@"remove");
            CGRect f = v.frame;
            f.origin.x -= f.size.width;
            v.frame = f;
        }
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)io 
                                 duration:(NSTimeInterval)duration {
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)io {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.blackRect removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


@end
