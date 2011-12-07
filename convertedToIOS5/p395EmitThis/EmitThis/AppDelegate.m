// new example, probably would be appended to end of chapter 17

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

@synthesize window = _window;

#define which 1
// try 2, 3, 4

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    
    
    // make a filled circle so we have something to emit
    UIGraphicsBeginImageContext(CGSizeMake(10,10));
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(con, CGRectMake(0,0,10,10));
    CGContextSetFillColorWithColor(con, [UIColor grayColor].CGColor);
    CGContextFillPath(con);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CAEmitterLayer* emit = [[CAEmitterLayer alloc] init];
    
    // emit slowly and regularly so it's obvious what's going on
    CAEmitterCell* cell = [CAEmitterCell emitterCell];
    cell.birthRate = 5; 
    cell.lifetime = 1; 
    cell.velocity = 100;
    cell.contents = (id)im.CGImage;

    switch (which) {
        case 1: break;
        case 2: {
            cell.birthRate = 100; 
            cell.lifetime = 1.5;
            cell.lifetimeRange = .4;
            cell.velocity = 100;
            cell.velocityRange = 20;
            cell.emissionRange = M_PI/5;
            cell.scale = 1;
            cell.scaleRange = .2;
            cell.scaleSpeed = .2;
            cell.xAcceleration = -40;
            cell.yAcceleration = 200;
            cell.color = [UIColor blueColor].CGColor;
            cell.greenRange = .5;
            cell.name = @"circle";
            
            CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"emitterCells.circle.greenSpeed"];
            ba.fromValue = [NSNumber numberWithFloat:-1];
            ba.toValue = [NSNumber numberWithFloat:3];
            ba.duration = 4;
            ba.autoreverses = YES;
            ba.repeatCount = HUGE_VALF;
            [emit addAnimation:ba forKey:nil];
            
            break;
        }
        case 3: case 4: {
            cell.birthRate = 100; 
            cell.lifetime = 1.5;
            cell.lifetimeRange = .4;
            cell.velocity = 100;
            cell.velocityRange = 20;
            cell.emissionRange = M_PI/5;
            cell.scale = 1;
            cell.scaleRange = .2;
            cell.scaleSpeed = .2;
            cell.xAcceleration = -40;
            cell.yAcceleration = 200;
            cell.color = [UIColor blueColor].CGColor;
            cell.greenRange = .5;
            cell.name = @"circle";
            
            CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"emitterCells.circle.greenSpeed"];
            ba.fromValue = [NSNumber numberWithFloat:-1];
            ba.toValue = [NSNumber numberWithFloat:3];
            ba.duration = 4;
            ba.autoreverses = YES;
            ba.repeatCount = HUGE_VALF;
            [emit addAnimation:ba forKey:nil];

            CAEmitterCell* cell2 = [CAEmitterCell emitterCell];
            cell.emitterCells = [NSArray arrayWithObject: cell2];
            cell2.contents = (id)im.CGImage;
            cell2.emissionRange = M_PI;
            cell2.birthRate = 200;
            cell2.lifetime = 0.4;
            cell2.velocity = 200;
            cell2.scale = 0.2;
            cell2.beginTime = .7;
            cell2.duration = .8;
        }
    }
    emit.emitterPosition = CGPointMake(30,100);
    emit.emitterShape = kCAEmitterLayerPoint;
    emit.emitterMode = kCAEmitterLayerPoints;
    switch (which) {
        case 1: case 2: case 3: break;
        case 4: {
            emit.emitterPosition = CGPointMake(100,25);
            emit.emitterSize = CGSizeMake(100,100);
            emit.emitterShape = kCAEmitterLayerLine;
            emit.emitterMode = kCAEmitterLayerOutline;
            cell.emissionLongitude = 3*M_PI/4;
        }
    }
    emit.emitterCells = [NSArray arrayWithObject:cell];
    [self.window.rootViewController.view.layer addSublayer:emit];

    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
