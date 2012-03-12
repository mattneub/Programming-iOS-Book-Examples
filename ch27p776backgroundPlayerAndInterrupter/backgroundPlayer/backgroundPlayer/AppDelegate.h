
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
