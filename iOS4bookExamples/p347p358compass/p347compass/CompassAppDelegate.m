

#import "CompassAppDelegate.h"
#import "CompassLayer.h"
#import "CompassView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CompassAppDelegate


@synthesize window=_window;
@synthesize compass = _compass;

#define which 1 // try "2" thru "9" for other examples

- (IBAction)animate:(id)sender {
    CompassLayer* c = (CompassLayer*)self.compass.layer;
    switch (which) {
        case 1:
        {
            // p. 371
            c.theArrow.transform = CATransform3DRotate(c.theArrow.transform, M_PI/4.0, 0, 0, 1);
            break;
        }
        case 2:
        {
            // p. 372
            [CATransaction setAnimationDuration:0.8];
            c.theArrow.transform = CATransform3DRotate(c.theArrow.transform, M_PI/4.0, 0, 0, 1);
            break;
        }
        case 3:
        {
            // p. 374
            CAMediaTimingFunction* clunk = 
                [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
            [CATransaction setAnimationTimingFunction: clunk];
            c.theArrow.transform = CATransform3DRotate(c.theArrow.transform, M_PI/4.0, 0, 0, 1);
            break;
        }
        case 4:
        {
            // p. 377
            // capture the start and end values
            CATransform3D startValue = c.theArrow.transform;
            CATransform3D endValue = CATransform3DRotate(startValue, M_PI/4.0, 0, 0, 1);
            // change the layer, without implicit animation
            [CATransaction setDisableActions:YES];
            c.theArrow.transform = endValue;
            // construct the explicit animation
            CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
            anim.duration = 0.8;
            CAMediaTimingFunction* clunk = 
            [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
            anim.timingFunction = clunk;
            anim.fromValue = [NSValue valueWithCATransform3D:startValue];
            anim.toValue = [NSValue valueWithCATransform3D:endValue];
            // ask for the explicit animation
            [c.theArrow addAnimation:anim forKey:nil];
            break;
        }
        case 5:
        {
            // p. 377
            [CATransaction setDisableActions:YES];
            c.theArrow.transform = CATransform3DRotate(c.theArrow.transform, M_PI/4.0, 0, 0, 1);
            CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
            anim.duration = 0.8;
            CAMediaTimingFunction* clunk = 
            [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
            anim.timingFunction = clunk;
            [c.theArrow addAnimation:anim forKey:nil];
            break;
        }
        case 6:
        {
            // p. 378
            // capture the start and end values
            CATransform3D nowValue = c.theArrow.transform;
            CATransform3D startValue = CATransform3DRotate(nowValue, M_PI/40.0, 0, 0, 1);
            CATransform3D endValue = CATransform3DRotate(nowValue, -M_PI/40.0, 0, 0, 1);
            // construct the explicit animation
            CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
            anim.duration = 0.05;
            anim.timingFunction = 
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            anim.repeatCount = 3;
            anim.autoreverses = YES;
            anim.fromValue = [NSValue valueWithCATransform3D:startValue];
            anim.toValue = [NSValue valueWithCATransform3D:endValue];
            // ask for the explicit animation
            [c.theArrow addAnimation:anim forKey:nil];
            break;
        }
        case 7:
        {
            // p. 378
            CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
            anim.duration = 0.05;
            anim.timingFunction = 
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            anim.repeatCount = 3;
            anim.autoreverses = YES;
            anim.additive = YES;
            anim.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
            anim.fromValue = [NSNumber numberWithFloat:M_PI/40];
            anim.toValue = [NSNumber numberWithFloat:-M_PI/40];
            [c.theArrow addAnimation:anim forKey:nil];
            break;
        }
        case 8:
        {
            // p. 379
            NSMutableArray* values = [NSMutableArray array];
            [values addObject: [NSNumber numberWithFloat:0]];
            int direction = 1;
            for (int i = 20; i < 60; i += 5, direction *= -1) { // reverse direction each time
                [values addObject: [NSNumber numberWithFloat: direction*M_PI/(float)i]];
            }
            [values addObject: [NSNumber numberWithFloat:0]];
            CAKeyframeAnimation* anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            anim.values = values;
            anim.additive = YES;
            anim.valueFunction = [CAValueFunction functionWithName: kCAValueFunctionRotateZ];
            [c.theArrow addAnimation:anim forKey:nil];
            break;
        }
        case 9:
        {
            // p. 381
            // capture current value, set final value
            CGFloat rot = M_PI/4.0;
            [CATransaction setDisableActions:YES];
            CGFloat current = [[c.theArrow valueForKeyPath:@"transform.rotation.z"] floatValue];
            [c.theArrow setValue: [NSNumber numberWithFloat: current + rot] 
                      forKeyPath:@"transform.rotation.z"];
            // first animation (rotate and clunk) ===============
            CABasicAnimation* anim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
            anim1.duration = 0.8;
            CAMediaTimingFunction* clunk = 
            [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
            anim1.timingFunction = clunk;
            anim1.fromValue = [NSNumber numberWithFloat: current];
            anim1.toValue = [NSNumber numberWithFloat: current + rot];
            anim1.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
            // second animation (waggle) ========================
            NSMutableArray* values = [NSMutableArray array];
            [values addObject: [NSNumber numberWithFloat:0]];
            int direction = 1;
            for (int i = 20; i < 60; i += 5, direction *= -1) { // reverse direction each time
                [values addObject: [NSNumber numberWithFloat: direction*M_PI/(float)i]];
            }
            [values addObject: [NSNumber numberWithFloat:0]];
            CAKeyframeAnimation* anim2 = 
            [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            anim2.values = values;
            anim2.duration = 0.25;
            anim2.beginTime = anim1.duration;
            anim2.additive = YES;
            anim2.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
            // group ============================================
            CAAnimationGroup* group = [CAAnimationGroup animation];
            group.animations = [NSArray arrayWithObjects: anim1, anim2, nil];
            group.duration = anim1.duration + anim2.duration;
            [c.theArrow addAnimation:group forKey:nil];
            break;
        }
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_compass release];
    [super dealloc];
}

@end
