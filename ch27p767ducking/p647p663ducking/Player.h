

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Player : NSObject 
@property (nonatomic, retain) AVAudioPlayer* player;
@property (nonatomic) BOOL forever;
- (void) play: (NSString*) path;
@end
