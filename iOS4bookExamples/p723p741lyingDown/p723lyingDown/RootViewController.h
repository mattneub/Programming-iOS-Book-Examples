

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIAccelerometerDelegate> {
    CGFloat oldX, oldY, oldZ;
    NSInteger state;
    UILabel *label;
}
@property (nonatomic, retain) IBOutlet UILabel *label;

@end
