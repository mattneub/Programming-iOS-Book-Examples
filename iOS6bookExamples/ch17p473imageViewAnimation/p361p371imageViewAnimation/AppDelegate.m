

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self animate];
    });
    return YES;
}

#define which 2 // try 2 and 3 for animated image, new feature in iOS 5

// also, for a related kind of image-based animation, see ch15p369filters example
// iOS 6 now has CIFilter transitions, which create the frames of an animation for you

- (void) animate {
    switch (which) {
        case 1: {
            UIImage* mars = [UIImage imageNamed: @"mars.png"];
            UIGraphicsBeginImageContextWithOptions(mars.size, NO, 0);
            UIImage* empty = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSArray* arr = @[mars, empty, mars, empty, mars];
            UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(56, 63, 208, 208)];
            [self.window.rootViewController.view addSubview: iv];
            iv.animationImages = arr;
            iv.animationDuration = 2;
            iv.animationRepeatCount = 1;
            [iv startAnimating];
            break;
        }
        case 2: {
            // new feature in iOS 5: animated images
            // the image animates for as long as it is shown
            // in this example, that's forever!
            // The idea here is that you can do this in *any* context where an image is displayed...
            // not just in an image view
            // but I'm using an image view to illustrate anyway
            UIImage* mars = [UIImage imageNamed: @"mars.png"];
            UIGraphicsBeginImageContextWithOptions(mars.size, NO, 0);
            UIImage* empty = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSArray* arr = @[mars, empty, mars, empty, mars, empty];
            UIImage* im = [UIImage animatedImageWithImages:arr duration:2];
            UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(56, 63, 208, 208)];
            iv.image = im;
            [self.window.rootViewController.view addSubview: iv];
            break;
        }
        case 3: {
            // even though we haven't formally discussed buttons,
            // here's one with an animated image
            NSMutableArray* arr = [NSMutableArray array];
            float w = 18;
            for (int i = 0; i < 6; i++) {
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,w), NO, 0);
                CGContextRef con = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(con, [UIColor redColor].CGColor);
                CGContextAddEllipseInRect(con, CGRectMake(0+i,0+i,w-i*2,w-i*2));
                CGContextFillPath(con);
                UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [arr addObject:im];
            }
            UIImage* im = [UIImage animatedImageWithImages:arr duration:0.5];
            UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [b setTitle:@"Howdy" forState:UIControlStateNormal];
            [b setImage:im forState:UIControlStateNormal];
            b.center = CGPointMake(100,100);
            [b sizeToFit];
            [self.window.rootViewController.view addSubview:b];
            break;
        }
    }
    
    


}


@end
