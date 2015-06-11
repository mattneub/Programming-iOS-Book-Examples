
#import <UIKit/UIKit.h>
@import AudioToolbox;

@interface SystemSoundHelper : NSObject
- (AudioServicesSystemSoundCompletionProc) completionHandler ;
void soundFinished (SystemSoundID snd, void* context);
@end
