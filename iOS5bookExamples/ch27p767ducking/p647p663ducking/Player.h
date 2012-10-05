

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Player : NSObject <AVAudioPlayerDelegate> 
@property (nonatomic, retain) AVAudioPlayer* player;
@property (nonatomic) BOOL forever;
- (void) play: (NSString*) path;
@end
