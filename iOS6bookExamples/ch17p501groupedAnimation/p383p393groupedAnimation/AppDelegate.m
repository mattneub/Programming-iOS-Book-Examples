

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()
@property (strong, nonatomic) UIView *view;
@end

@implementation AppDelegate


- (void) animate {
    CGFloat h = 200;
    CGFloat v = 75;
    CGMutablePathRef path = CGPathCreateMutable();
    int leftright = 1;
    CGPoint next = self.view.layer.position;
    CGPoint pos;
    CGPathMoveToPoint(path, nil, next.x, next.y);
    for (int i = 0; i < 4; i++) {
        pos = next;
        leftright *= -1;
        next = CGPointMake(pos.x+h*leftright, pos.y+v);
        CGPathAddCurveToPoint(path, nil, pos.x, pos.y+30, next.x, next.y-30, 
                              next.x, next.y);
    }
    CAKeyframeAnimation* anim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim1.path = path;
    anim1.calculationMode = kCAAnimationPaced;
    NSArray* revs = @[@0.0f,
                     @M_PI,
                     @0.0f,
                     @M_PI];
    CAKeyframeAnimation* anim2 = 
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim2.values = revs;
    anim2.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateY];
    anim2.calculationMode = kCAAnimationDiscrete;
    NSArray* pitches = @[@0.0f,
                        @(M_PI/60.0),
                        @0.0f,
                        @(-M_PI/60.0),
                        @0.0f];
    CAKeyframeAnimation* anim3 = 
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim3.values = pitches;
    anim3.repeatCount = HUGE_VALF;
    anim3.duration = 0.5;
    anim3.additive = YES;
    anim3.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[anim1, anim2, anim3];
    group.duration = 8;
    [_view.layer addAnimation:group forKey:nil];
    [CATransaction setDisableActions:YES];
    _view.layer.position = next;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(254,28,56,38)];
    [self.window.rootViewController.view addSubview: self.view];
    self.view.layer.contents = (id)[[UIImage imageNamed:@"boat.gif"] CGImage];
    self.view.layer.contentsGravity = kCAGravityResizeAspectFill;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self animate];
    });
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
