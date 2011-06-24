

#import "RootViewController.h"
#import "Player.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation RootViewController
@synthesize player;

-(void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unduck:) name:@"soundFinished" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [player release];
    [super dealloc];
}

// instructions: run the app on a device
// play music with the iPod / Music app
// tap the Once button to experience ducking

// now tap the Forever button; we loop forever
// switch out to the remote controls to stop play (see p. 650)

// feel free to experiment further; if you set audio background mode in Info.plist,
// then Forever even plays when we are in the background

- (IBAction)doButton:(id)sender {
    // make sure Player object exists
    if (!self.player) {
        Player* p = [[Player alloc] init];
        self.player = p;
        [p release];
    }
    
    UInt32 duck = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, 
                            sizeof(duck), &duck);
        
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"aif"];
    if ([[(UIButton*)sender currentTitle] isEqualToString:@"Forever"]) {
        // for remote control to work, our audio session policy must be Playback
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: NULL];
        self.player.forever = YES;
    }
    else {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: NULL];
        self.player.forever = NO;
    }
    [self.player play:path];
}

- (void) unduck: (id) dummy {
    UInt32 duck = 0;
    AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, 
                            sizeof(duck), &duck);
    AudioSessionSetActive(false);
    AudioSessionSetActive(true);
}

// =========== respond to remote controls

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    UIEventSubtype rc = event.subtype;
    if (rc == UIEventSubtypeRemoteControlTogglePlayPause) {
        if ([self.player.player isPlaying])
            [self.player.player stop];
    }
}



@end
