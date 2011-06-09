
#import <UIKit/UIKit.h>

@interface ImageViewAnimationAppDelegate : NSObject <UIApplicationDelegate> {
    UIImageView* iv;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIImageView *iv;

@end
