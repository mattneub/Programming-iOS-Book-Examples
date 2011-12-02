

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    
    UIImage* moi = [UIImage imageNamed:@"moi.jpg"];
    CIImage* moi2 = [[CIImage alloc] initWithCGImage:moi.CGImage];
    
    CIFilter* grad = [CIFilter filterWithName:@"CIRadialGradient"];
    CIVector* center = [CIVector vectorWithX:moi.size.width/2.0 Y:moi.size.height/2.0];
    [grad setValue:center forKey:@"inputCenter"];
    CIFilter* dark = [CIFilter filterWithName:@"CIDarkenBlendMode"
                               keysAndValues:
                     @"inputImage", grad.outputImage,
                     @"inputBackgroundImage", moi2,
                     nil];
    
    CIContext* con = [CIContext contextWithOptions:nil];
    CGImageRef moi3 = [con createCGImage:dark.outputImage
                                fromRect:moi2.extent];
    UIImage* moi4 = [UIImage imageWithCGImage:moi3];
    CGImageRelease(moi3);
    
    UIImageView* iv = [[UIImageView alloc] initWithImage:moi4];
    iv.backgroundColor = [UIColor blackColor];
    [self.window.rootViewController.view addSubview: iv];
    iv.center = self.window.center;

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
