

#import <Foundation/Foundation.h>
#include <AVFoundation/AVFoundation.h>

@class AVAudioPlayer;

@interface Player : NSObject <AVAudioPlayerDelegate> 
@property (nonatomic, retain) AVAudioPlayer *player;
- (void) play: (NSString*) path;
@end
