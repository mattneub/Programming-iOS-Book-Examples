
#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIAccelerometerDelegate> {
    CGFloat oldX, oldY, oldZ;
    NSTimeInterval oldTime;
    NSInteger lastSlap;
}

@end
