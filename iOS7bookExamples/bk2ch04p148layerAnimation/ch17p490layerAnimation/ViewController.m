

#import "ViewController.h"
#import "CompassView.h"
#import "CompassLayer.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CompassView *compassView;

@end

@implementation ViewController

- (IBAction)doButton:(id)sender {
    CompassLayer* c = (CompassLayer*)self.compassView.layer;
    CALayer* arrow = c.arrow;
    
#define which 1
    
#if which == 1
    
    arrow.transform = CATransform3DRotate(arrow.transform, M_PI/4.0, 0, 0, 1);

#elif which == 2
    
    [CATransaction setAnimationDuration:0.8];
    arrow.transform = CATransform3DRotate(arrow.transform, M_PI/4.0, 0, 0, 1);
    
#elif which == 3
    
    CAMediaTimingFunction* clunk =
    [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
    [CATransaction setAnimationTimingFunction: clunk];
    arrow.transform = CATransform3DRotate(arrow.transform, M_PI/4.0, 0, 0, 1);

#elif which == 4
    
    // proving that completion block works
    [CATransaction setCompletionBlock:^{
        NSLog(@"%@", @"done");
    }];

    // capture the start and end values
    CATransform3D startValue = arrow.transform;
    CATransform3D endValue = CATransform3DRotate(startValue, M_PI/4.0, 0, 0, 1);
    // change the layer, without implicit animation
    [CATransaction setDisableActions:YES];
    arrow.transform = endValue;
    // construct the explicit animation
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.8;
    CAMediaTimingFunction* clunk =
    [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
    anim.timingFunction = clunk;
    anim.fromValue = [NSValue valueWithCATransform3D:startValue];
    anim.toValue = [NSValue valueWithCATransform3D:endValue];
    // ask for the explicit animation
    [arrow addAnimation:anim forKey:nil];
    
#elif which == 5
    
    [CATransaction setDisableActions:YES];
    arrow.transform = CATransform3DRotate(arrow.transform, M_PI/4.0, 0, 0, 1);
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.8;
    CAMediaTimingFunction* clunk =
    [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
    anim.timingFunction = clunk;
    [arrow addAnimation:anim forKey:nil];
    
#elif which == 6

    // capture the start and end values
    CATransform3D nowValue = arrow.transform;
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
    [arrow addAnimation:anim forKey:nil];

#elif which == 7
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.05;
    anim.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.repeatCount = 3;
    anim.autoreverses = YES;
    anim.additive = YES;
    anim.valueFunction =
    [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    anim.fromValue = @(M_PI/40);
    anim.toValue = @(-M_PI/40);
    [arrow addAnimation:anim forKey:nil];

#elif which == 8
    
    NSMutableArray* values = [NSMutableArray array];
    [values addObject: @0.0f];
    int direction = 1;
    for (int i = 20; i < 60; i += 5, direction *= -1) { // alternate directions
        [values addObject: @(direction*M_PI/(float)i)];
    }
    [values addObject: @0.0f];
    CAKeyframeAnimation* anim =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = values;
    anim.additive = YES;
    anim.valueFunction =
    [CAValueFunction functionWithName: kCAValueFunctionRotateZ];
    [arrow addAnimation:anim forKey:nil];

#elif which == 9
    
    // capture current value, set final value
    CGFloat rot = M_PI/4.0;
    [CATransaction setDisableActions:YES];
    CGFloat current =
    [[arrow valueForKeyPath:@"transform.rotation.z"] floatValue];
    [arrow setValue: @(current + rot)
         forKeyPath:@"transform.rotation.z"];
    
    // first animation (rotate and clunk)
    CABasicAnimation* anim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim1.duration = 0.8;
    CAMediaTimingFunction* clunk =
    [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
    anim1.timingFunction = clunk;
    anim1.fromValue = @(current);
    anim1.toValue = @(current + rot);
    anim1.valueFunction =
    [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    
    // second animation (waggle)
    NSMutableArray* values = [NSMutableArray array];
    [values addObject: @0.0f];
    int direction = 1;
    for (int i = 20; i < 60; i += 5, direction *= -1) { // alternate directions
        [values addObject: @(direction*M_PI/(float)i)];
    }
    [values addObject: @0.0f];
    CAKeyframeAnimation* anim2 =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim2.values = values;
    anim2.duration = 0.25;
    anim2.beginTime = anim1.duration;
    anim2.additive = YES;
    anim2.valueFunction =
    [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    
    // group
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[anim1, anim2];
    group.duration = anim1.duration + anim2.duration;
    [arrow addAnimation:group forKey:nil];

    
#endif
    
    
}


@end
