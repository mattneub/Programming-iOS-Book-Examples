

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MyLayer.h"

@implementation AppDelegate {
    CALayer* lay;
}

@synthesize window = _window;

#define which 1 // try also "2" thru "5"

- (void) animate {
    
    switch (which) {
        case 1: {
            CALayer* layer = self->lay;
            
            // put a "position" entry into the layer's actions dictionary
            CABasicAnimation* ba = [CABasicAnimation animation];
            ba.duration = 5;
            layer.actions = [NSDictionary dictionaryWithObject: ba forKey: @"position"];
            layer.delegate = nil; // use actions dictionary, not delegate

            // use implicit property animation
            CGPoint newP = CGPointMake(200,300);
            [CATransaction setAnimationDuration:1.5];
            layer.position = newP; 
            // the animation "ba" will be used, with its 5-second duration
            
            break;
        }
        case 2:
        {
            CALayer* layer = self->lay;
            CGPoint newP = CGPointMake(200,300);
            [CATransaction setValue: [NSValue valueWithCGPoint: newP] forKey: @"newP"];
            [CATransaction setAnimationDuration:1.5];
            layer.position = newP; 
            // the delegate will waggle the layer into place
            
            break;
        }
        case 3:
        {
            CALayer* layer = self->lay;
            layer.contents =  (id)[[UIImage imageNamed:@"Saturn.gif"] CGImage];
            // the layer subclass (MyLayer) will turn this into a push transition
            break;
        }
        case 4:
        {
            // p 394
            CALayer* layer = [CALayer layer];
            layer.frame = CGRectMake(200,50,40,40);
            layer.contents = (id)[[UIImage imageNamed:@"Saturn.gif"] CGImage];
            layer.delegate = self;
            [self.window.rootViewController.view.layer addSublayer:layer]; 
            // the delegate will "pop" the layer as it appears
            break;
        }
        case 5:
        {
            CALayer* layer = self->lay;
            [CATransaction setCompletionBlock: ^{
                [layer removeFromSuperlayer];
            }];
            [CATransaction setValue:@"" forKey:@"byebye"];
            layer.opacity = 0; 
            // the delegate will "shrink" the layer as it disappears
            break;
        }
    }
}



- (id < CAAction >)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
    if ([key isEqualToString: @"position"]) {
        CGPoint oldP = layer.position;
        CGPoint newP = [[CATransaction valueForKey: @"newP"] CGPointValue];
        CGFloat d = sqrt(pow(oldP.x - newP.x, 2) + pow(oldP.y - newP.y, 2));
        CGFloat r = d/3.0;
        CGFloat theta = atan2(newP.y - oldP.y, newP.x - oldP.x);
        CGFloat wag = 10*M_PI/180.0;
        CGPoint p1 = CGPointMake(oldP.x + r*cos(theta+wag), 
                                 oldP.y + r*sin(theta+wag));
        CGPoint p2 = CGPointMake(oldP.x + r*2*cos(theta-wag), 
                                 oldP.y + r*2*sin(theta-wag));
        CAKeyframeAnimation* anim = [CAKeyframeAnimation animation];
        anim.values = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:oldP],
                       [NSValue valueWithCGPoint:p1],
                       [NSValue valueWithCGPoint:p2],
                       [NSValue valueWithCGPoint:newP],
                       nil];
        anim.calculationMode = kCAAnimationCubic;
        return anim;
    }
    if ([key isEqualToString:kCAOnOrderIn]) {
        CABasicAnimation* anim1 = 
        [CABasicAnimation animationWithKeyPath:@"opacity"];
        anim1.fromValue = [NSNumber numberWithFloat: 0.0];
        anim1.toValue = [NSNumber numberWithFloat: layer.opacity];
        CABasicAnimation* anim2 = 
        [CABasicAnimation animationWithKeyPath:@"transform"];
        anim2.toValue = [NSValue valueWithCATransform3D:
                         CATransform3DScale(layer.transform, 1.2, 1.2, 1.0)];
        anim2.autoreverses = YES;
        anim2.duration = 0.1;
        CAAnimationGroup* group = [CAAnimationGroup animation];
        group.animations = [NSArray arrayWithObjects: anim1, anim2, nil];
        group.duration = 0.2;
        return group;
    }
    if ([key isEqualToString:@"opacity"]) {
        if ([CATransaction valueForKey:@"byebye"]) {
            CABasicAnimation* anim1 = 
            [CABasicAnimation animationWithKeyPath:@"opacity"];
            anim1.fromValue = [NSNumber numberWithFloat: layer.opacity];
            anim1.toValue = [NSNumber numberWithFloat: 0.0];
            CABasicAnimation* anim2 = 
            [CABasicAnimation animationWithKeyPath:@"transform"];
            anim2.toValue = [NSValue valueWithCATransform3D:
                             CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)];
            CAAnimationGroup* group = [CAAnimationGroup animation];
            group.animations = [NSArray arrayWithObjects: anim1, anim2, nil];
            group.duration = 0.2;
            return group;
        }
    }
    return nil;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    CALayer* layer = [MyLayer layer];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        layer.delegate = self; // moved here to prevent pop animation on startup
                               // not quite sure why setDisableActions:YES fails to prevent it
    }];
    layer.frame = CGRectMake(50,50,40,40);
    //layer.backgroundColor = [[UIColor redColor] CGColor];
    layer.contents = (id)[[UIImage imageNamed:@"Mars.png"] CGImage];
    
    [self.window.rootViewController.view.layer addSublayer:layer];
    self->lay = layer;
    
    [self performSelector:@selector(animate) withObject:self afterDelay:1];

    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
