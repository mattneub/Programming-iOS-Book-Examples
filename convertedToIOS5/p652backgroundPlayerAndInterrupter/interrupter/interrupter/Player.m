

#import "Player.h"
#include <AVFoundation/AVFoundation.h>


@interface Player()
@property (nonatomic, copy) NSString* soundPath;
@end;

@implementation Player

@synthesize player; // the player object
@synthesize soundPath;

- (void) play2: (NSString*) path {
        
    self.soundPath = path;
    
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
	
	AVAudioPlayer *newPlayer =
	[[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
										   error: nil];
	
	self.player = newPlayer;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
//    player.enableRate = YES;
//    player.rate = 1.2; // cool new iOS 5 feature, may as well play with it
	[player setDelegate: self];
	[player prepareToPlay];
	BOOL ok = [player play];
    NSLog(@"trying to play %@ %i", path, ok);
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag {
    NSLog(@"audio finished %i", flag);
    [[AVAudioSession sharedInstance] setActive:NO withFlags:AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation error:nil];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p {
    NSLog(@"audio player interrupted at %f", player.currentTime);
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)p withFlags:(NSUInteger) flags {
    NSLog(@"audio player interruption ended with flags %i", flags);

    if (flags & AVAudioSessionInterruptionFlags_ShouldResume) {
        // but this is just a test, always try to resume
    }
    [p prepareToPlay];
    BOOL ok = [p play];
    NSLog(@"tried to play; did I? %i", ok);
}
 

- (void) play: (NSString*) path {
	[self play2: path];
}


@end
