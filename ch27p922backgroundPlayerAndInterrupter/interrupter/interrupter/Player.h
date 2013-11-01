

#import <Foundation/Foundation.h>

@class AVAudioPlayer;

@interface Player : NSObject  
@property (nonatomic, strong) AVAudioPlayer *player;
- (void) play: (NSString*) path;
@end
