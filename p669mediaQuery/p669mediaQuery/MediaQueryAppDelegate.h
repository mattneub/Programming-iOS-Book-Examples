

#import <UIKit/UIKit.h>

@interface MediaQueryAppDelegate : NSObject <UIApplicationDelegate> {

    IBOutlet UIProgressView *p;
    IBOutlet UILabel *label;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSTimer* timer;
@end
