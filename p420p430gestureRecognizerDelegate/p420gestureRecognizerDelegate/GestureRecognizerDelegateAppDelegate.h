

#import <UIKit/UIKit.h>

@interface GestureRecognizerDelegateAppDelegate : NSObject <UIApplicationDelegate, UIGestureRecognizerDelegate> {

    UIView *view;
    CGPoint origC;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIView *view;
@property (nonatomic, retain) UILongPressGestureRecognizer* longPresser;
@end
