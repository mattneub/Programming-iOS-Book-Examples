

#import <Foundation/Foundation.h>
@class AVAudioPlayer;

@interface Player : NSObject 
@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic) BOOL forever;
- (void) play: (NSString*) path;
@end
