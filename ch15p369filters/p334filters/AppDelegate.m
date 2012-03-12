

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

#define which 1 // or 2 for non-Core Image

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    
    UIImage* moi = [UIImage imageNamed:@"moi.jpg"];
    CIImage* moi2 = [[CIImage alloc] initWithCGImage:moi.CGImage];
    UIImage* moi4;
    
    switch (which) {
        case 1: {
            
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
            moi4 = [UIImage imageWithCGImage:moi3];
            CGImageRelease(moi3);
            
            break;
        }
        case 2: {
            UIGraphicsBeginImageContextWithOptions(moi.size, YES, 0);
            CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
            CFArrayRef arr = (__bridge CFArrayRef)[NSArray arrayWithObjects:
                                                   (id)[UIColor whiteColor].CGColor,
                                                   [UIColor blackColor].CGColor,
                                                   nil];
            CGFloat locs[] = {0, .9};
            CGGradientRef grad = CGGradientCreateWithColors(space, arr, locs);
            CGColorSpaceRelease(space);
            CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), grad, 
                                        CGPointMake(moi.size.width/2.0, moi.size.height/2.0),
                                        0, 
                                        CGPointMake(moi.size.width/2.0, moi.size.height/2.0), 
                                        moi.size.width/2.0,
                                        kCGGradientDrawsBeforeStartLocation);
            CGGradientRelease(grad);
            UIImage* gradimage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIGraphicsBeginImageContextWithOptions(moi.size, YES, 0);
            [moi drawAtPoint:CGPointZero];
            [gradimage drawAtPoint:CGPointZero blendMode:kCGBlendModeDarken alpha:1.0];
            moi4 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            break;
        }
    }
    
    
    UIImageView* iv = [[UIImageView alloc] initWithImage:moi4];
    iv.backgroundColor = [UIColor blackColor];
    [self.window.rootViewController.view addSubview: iv];
    iv.center = self.window.center;

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
