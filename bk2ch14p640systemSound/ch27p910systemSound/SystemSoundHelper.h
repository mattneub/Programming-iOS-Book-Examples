
#import <UIKit/UIKit.h>
@import AudioToolbox;

@interface SystemSoundHelper : NSObject
- (AudioServicesSystemSoundCompletionProc) completionHandler ;
@end
