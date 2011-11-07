// new example, probably would be appended to end of chapter 17

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    
    // create world's simplest emitter example!
    CAEmitterLayer* emit = [[CAEmitterLayer alloc] init];
    emit.emitterPosition = CGPointMake(30,100);
    emit.emitterShape = kCAEmitterLayerPoint;
    emit.emitterMode = kCAEmitterLayerPoints;
    [self.window.rootViewController.view.layer addSublayer:emit];
    
    // make a filled circle so we have something to emit
    UIGraphicsBeginImageContext(CGSizeMake(10,10));
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(con, CGRectMake(0,0,10,10));
    CGContextSetFillColorWithColor(con, [UIColor grayColor].CGColor);
    CGContextFillPath(con);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // emit slowly and regularly so it's obvious what's going on
    CAEmitterCell* cell = [CAEmitterCell emitterCell];
    emit.emitterCells = [NSArray arrayWithObject:cell];
    cell.birthRate = 5; 
    cell.lifetime = 1; 
    cell.velocity = 100;
    cell.contents = (id)im.CGImage;
    // and you can experiment with other properties and settings

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.window.rootViewController.view.layer.backgroundColor = [UIColor greenColor].CGColor; // make moment visible
        cell.emissionLongitude = M_PI/2.0;
      // what I expect: the stream of cells should turn 90 degrees
      // but it doesn't; nothing happens!
      // however, it *does* happen if you uncomment this next line!
      // so it appears that changing something about the emitter causes the change in the cell to "take"
      // emit.birthRate = 1.01;
        // but then there's *another* problem; these changes are said to be "animatable"
        // but they are not animating! the change in the emissionLongitude is instantaneous
    });
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
