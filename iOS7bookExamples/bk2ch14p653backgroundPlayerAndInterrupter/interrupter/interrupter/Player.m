

#import "Player.h"
@import AVFoundation;


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
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:nil];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:0 error:nil];
    
//    player.enableRate = YES;
//    player.rate = 1.2; // cool feature
    
	[self.player setDelegate: self];
	[self.player prepareToPlay];
	BOOL ok = [self.player play];
    NSLog(@"trying to play %@ %d", path, ok);
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag {
    NSLog(@"audio finished %d", flag);

    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:0 error:nil];
    [[AVAudioSession sharedInstance] setActive: YES withOptions:0 error:nil];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p {
    NSLog(@"audio player interrupted at %f", self.player.currentTime);
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)p withOptions:(NSUInteger)opts {
    NSLog(@"audio player interruption ended with options %lu", (unsigned long)opts);

    if (opts & AVAudioSessionInterruptionOptionShouldResume) {
        NSLog(@"I was told to resume");
        // but this is just a test, always try to resume
    }
    [p prepareToPlay];
    BOOL ok = [p play];
    NSLog(@"tried to play; did I? %d", ok);
}
 

- (void) play: (NSString*) path {
	[self play2: path];
}


@end
