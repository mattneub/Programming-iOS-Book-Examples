
#import <UIKit/UIKit.h>
@class MyView;

@interface CustomAnimatablePropertyAppDelegate : NSObject <UIApplicationDelegate> {

    MyView *_v;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MyView *v;

@end
