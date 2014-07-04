

#import "Player.h"
@import AVFoundation;
@import MediaPlayer;

@interface Player () <AVAudioPlayerDelegate>
@end

@implementation Player

- (void) play: (NSString*) path {
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    NSError* err = nil;
    AVAudioPlayer *newPlayer =
        [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: &err];
    // error-checking omitted

    self.player = newPlayer; // retain policy

    [self.player prepareToPlay];
    [self.player setDelegate: self];
    if (self.forever)
        self.player.numberOfLoops = -1;
    [self.player play];
    
    // cute little demo
    MPNowPlayingInfoCenter* mpic = [MPNowPlayingInfoCenter defaultCenter];
    mpic.nowPlayingInfo =
    @{MPMediaItemPropertyTitle:@"This Is a Test"};

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player // delegate method
                       successfully:(BOOL)flag {
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"soundFinished" object:nil];
}

// unnecessary to implement audioPlayerEndInterruption delegate method...
// ... merely to reactivate audio session after interrupt; happens automatically
// also, automatically resumes after interruption


-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"audio player interrupted");
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)opts {
    NSLog(@"audio player ended interruption options: %lu", (unsigned long)opts);
}


@end
