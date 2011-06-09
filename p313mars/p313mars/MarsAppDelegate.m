

#import "MarsAppDelegate.h"

@implementation MarsAppDelegate


@synthesize window=_window;

CGImageRef flip (CGImageRef im) {
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    UIGraphicsBeginImageContext(sz);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), im);
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    return result;
}



#define which 1 // substitute "2" thru "9" for other examples

// try all examples with both single-resolution and double-resolution device
// the double-resolution Mars image has "2" in it so you can see when it is being used

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    switch (which) {
        case 1:
        {
            UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mars.png"]];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;
        }
        case 2:
        {
            // figure 15-1
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*2, sz.height), NO, 0.0);
            [mars drawAtPoint:CGPointMake(0,0)];
            [mars drawAtPoint:CGPointMake(sz.width,0)];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;
        }
        case 3: 
        {
            // figure 15-2
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*2, sz.height*2), NO, 0.0);
            [mars drawInRect:CGRectMake(0,0,sz.width*2,sz.height*2)];
            [mars drawInRect:CGRectMake(sz.width/2.0, sz.height/2.0, sz.width, sz.height) 
                   blendMode:kCGBlendModeMultiply alpha:1.0];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;
        }
        case 4:
        {
            // figure 15-3
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width/2.0, sz.height), NO, 0.0);
            [mars drawAtPoint:CGPointMake(-sz.width/2.0, 0)];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;
        }
        case 5:
        {
            // figure 15-4
            // incorrectly flipped, doesn't work on double-resolution device
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            // extract each half as a CGImage
            CGSize sz = [mars size];
            CGImageRef marsLeft = CGImageCreateWithImageInRect([mars CGImage], 
                                                               CGRectMake(0,0,sz.width/2.0,sz.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect([mars CGImage], 
                                                                CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
            // draw each CGImage into an image context
            UIGraphicsBeginImageContext(CGSizeMake(sz.width*1.5, sz.height));
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextDrawImage(con, CGRectMake(0,0,sz.width/2.0,sz.height), marsLeft);
            CGContextDrawImage(con, CGRectMake(sz.width,0,sz.width/2.0,sz.height), marsRight);
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);

            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;
        }
        case 6:
        {
            // same as previous; flipping solution #1
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            // extract each half as a CGImage
            CGSize sz = [mars size];
            CGImageRef marsLeft = CGImageCreateWithImageInRect([mars CGImage], 
                                                               CGRectMake(0,0,sz.width/2.0,sz.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect([mars CGImage], 
                                                                CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
            // draw each CGImage into an image context
            UIGraphicsBeginImageContext(CGSizeMake(sz.width*1.5, sz.height));
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextDrawImage(con, CGRectMake(0,0,sz.width/2.0,sz.height), flip(marsLeft));
            CGContextDrawImage(con, CGRectMake(sz.width,0,sz.width/2.0,sz.height), flip(marsRight));
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;
        }
        case 7:
        {
            // same as previous; flipping solution #2
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            // extract each half as a CGImage
            CGSize sz = [mars size];
            CGImageRef marsLeft = CGImageCreateWithImageInRect([mars CGImage], 
                                                               CGRectMake(0,0,sz.width/2.0,sz.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect([mars CGImage], 
                                                                CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
            // draw each CGImage into an image context
            UIGraphicsBeginImageContext(CGSizeMake(sz.width*1.5, sz.height));
            // CGContextRef con = UIGraphicsGetCurrentContext();
            [[UIImage imageWithCGImage:marsLeft] drawAtPoint:CGPointMake(0,0)];
            [[UIImage imageWithCGImage:marsRight] drawAtPoint:CGPointMake(sz.width,0)];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;
        }
        case 8:
        {
            // works on double-resolution device, flipping solution #1
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            // Derive CGImage and use its dimensions to extract its halves
            CGImageRef marsCG = [mars CGImage];
            CGSize szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));
            CGImageRef marsLeft = CGImageCreateWithImageInRect(marsCG, 
                                                               CGRectMake(0,0,szCG.width/2.0,szCG.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect(marsCG, 
                                                                CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));
            // Use double-resolution graphics context if possible
            UIGraphicsBeginImageContextWithOptions(
                                                   CGSizeMake(sz.width*1.5, sz.height), NO, 0.0);
            // The rest is as before, calling flip() to compensate for flipping
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextDrawImage(
                               con, CGRectMake(0,0,sz.width/2.0,sz.height), flip(marsLeft));
            CGContextDrawImage(
                               con, CGRectMake(sz.width,0,sz.width/2.0,sz.height), flip(marsRight));
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;
        }
        case 9:
        {
            // works on double-resolution device, flipping solution #2
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            // Derive CGImage and use its dimensions to extract its halves
            CGImageRef marsCG = [mars CGImage];
            CGSize szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));
            CGImageRef marsLeft = CGImageCreateWithImageInRect(marsCG, 
                                                               CGRectMake(0,0,szCG.width/2.0,szCG.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect(marsCG, 
                                                                CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));
            // Use double-resolution graphics context if possible
            UIGraphicsBeginImageContextWithOptions(
                                                   CGSizeMake(sz.width*1.5, sz.height), NO, 0.0);
            [[UIImage imageWithCGImage:marsLeft 
                                 scale:[mars scale] 
                           orientation:UIImageOrientationUp] 
             drawAtPoint:CGPointMake(0,0)];
            [[UIImage imageWithCGImage:marsRight 
                                 scale:[mars scale] 
                           orientation:UIImageOrientationUp] 
             drawAtPoint:CGPointMake(sz.width,0)];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window addSubview: iv];
            iv.center = self.window.center;
            [iv release];
            break;

        }
    }

    
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
