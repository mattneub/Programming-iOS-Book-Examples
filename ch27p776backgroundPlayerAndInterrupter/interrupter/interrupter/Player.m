

#import "Player.h"
#include <AVFoundation/AVFoundation.h>


@interface Player() <AVAudioPlayerDelegate>
@property (nonatomic, copy) NSString* soundPath;
@end;

@implementation Player

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
	[self.player setDelegate: self];
	[self.player prepareToPlay];
	BOOL ok = [self.player play];
    NSLog(@"trying to play %@ %i", path, ok);
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag {
    NSLog(@"audio finished %i", flag);
//    [[AVAudioSession sharedInstance] setActive:NO withFlags:AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation error:nil];
    // above line deprecated in iOS 6, replaced with the following:
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:NULL];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:NULL];
    [[AVAudioSession sharedInstance] setActive: YES error:NULL];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p {
    NSLog(@"audio player interrupted at %f", self.player.currentTime);
}

// iOS 6 change, now use Options, not flags...
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)p withOptions:(NSUInteger)flags {
    NSLog(@"audio player interruption ended with flags %i", flags);

    // ... and the name of the flag has changed
    if (flags & AVAudioSessionInterruptionOptionShouldResume) {
        NSLog(@"I was told to resume");
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
