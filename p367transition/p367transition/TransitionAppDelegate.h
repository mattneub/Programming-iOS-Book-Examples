

#import <UIKit/UIKit.h>
@class MyView;
@interface TransitionAppDelegate : NSObject <UIApplicationDelegate> {

    UIImageView *iv;
    UIButton *b;
    MyView *v;
    UIView *v2;
    BOOL stopped;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIImageView *iv;
@property (nonatomic, retain) IBOutlet UIButton *b;
@property (nonatomic, retain) IBOutlet MyView *v;
@property (nonatomic, retain) IBOutlet UIView *v2;

@end
