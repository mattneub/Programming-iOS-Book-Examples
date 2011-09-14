

#import "Player.h"


@implementation Player
@synthesize player, forever;

- (void)dealloc {
    [player release];
    [super dealloc];
}

- (void) play: (NSString*) path {
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    NSError* err = nil;
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: &err];
    // error-checking omitted
    [fileURL release];
    self.player = newPlayer; // retain policy
    [newPlayer release];
    [self.player prepareToPlay];
    [self.player setDelegate: self];
    if (self.forever)
        self.player.numberOfLoops = -1;
    [self.player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player // delegate method
                       successfully:(BOOL)flag {
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"soundFinished" object:nil];
}

// unnecessary to implement audioPlayerEndInterruption delegate method...
// ... merely to reactivate audio session after interrupt; happens automatically
// also, automatically resumes after interruption!
// not sure when that started: not in iOS 4.0, I'm pretty sure,
// and the book is unaware of it (p. 650)


@end
