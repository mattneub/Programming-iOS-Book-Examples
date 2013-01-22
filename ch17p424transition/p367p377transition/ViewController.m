

#import "ViewController.h"
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic, retain) IBOutlet UIImageView *iv;
@property (nonatomic, retain) IBOutlet UIButton *b;
@property (nonatomic, retain) IBOutlet MyView *v;
@property (nonatomic, retain) IBOutlet UIView *v2;
@end;

@implementation ViewController

{
    BOOL stopped;
}


#define which 1 // try also "2" for block-based transition

// I've slowed down all the animations to make them clearer

- (void) animate {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                           forView:_iv cache:YES];
    [UIView setAnimationDuration:2];
    _iv.image = [UIImage imageNamed:@"Saturn.gif"];
    [UIView commitAnimations];
    // =======
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                           forView:_b cache:YES];
    [UIView setAnimationDuration:2];
    [_b setTitle:(stopped ? @"Start" : @"Stop") forState:UIControlStateNormal];
    [UIView commitAnimations];
    // =======
    switch (which) {
        case 1:
        {
            _v.reverse = !_v.reverse;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                   forView:_v cache:YES];
            [UIView setAnimationDuration:2];
            [_v setNeedsDisplay];
            [UIView commitAnimations];
            break;
        }
        case 2:
        {
            _v.reverse = !_v.reverse;
            void (^anim) (void) = ^{
                [_v setNeedsDisplay];
            };    
            NSUInteger opts = UIViewAnimationOptionTransitionFlipFromLeft;
            // new in iOS 5: three new block-based transition animation styles:
            // UIViewAnimationOptionTransitionCrossDissolve
            // UIViewAnimationOptionTransitionFlipFromBottom
            // UIViewAnimationOptionTransitionFlipFromTop
            // so these are things you can do with block-based view transition...
            // that you can't do with old style animation block view transition
            [UIView transitionWithView:_v duration:2 options:opts 
                            animations:anim completion:nil];
            break;
        }
    }
    // =======
    CALayer* layer = [_v2.layer.sublayers lastObject];
    CATransition* t = [CATransition animation];
    t.type = kCATransitionPush;
    t.subtype = kCATransitionFromBottom;
    t.duration = 2;
    [CATransaction setDisableActions:YES];
    layer.contents = (id)[[UIImage imageNamed: @"Saturn.gif"] CGImage];
    [layer addAnimation: t forKey: nil];
}

- (void) viewDidLoad {
    CALayer* layer = [CALayer layer];
    layer.frame = _v2.layer.bounds;
    [_v2.layer addSublayer:layer];
    layer.contents = (id)[[UIImage imageNamed:@"Mars.png"] CGImage];
    layer.contentsGravity = kCAGravityCenter;
    _v2.layer.masksToBounds = YES; // try making this NO to see what difference it makes
    _v2.layer.borderWidth = 2;
    
    // added the following, to confirm that user touch interactions are still disabled by default
    // on a view undergoing a block-based view animation - yes, they are
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_v addGestureRecognizer:tap];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self animate];
    });
}

-(void) tap:(id)dummy {
    NSLog(@"tapped");
}

@end
