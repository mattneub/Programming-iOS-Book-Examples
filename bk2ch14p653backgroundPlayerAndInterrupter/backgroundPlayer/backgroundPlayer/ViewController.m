

#import "ViewController.h"
#import "Player.h"
@import MediaPlayer;
@import AVFoundation;

@interface ViewController()
@property (nonatomic, strong) Player* player;
@end

@implementation ViewController

- (IBAction) doButton: (id) sender {
    // start playing from beginning
    NSString* path = [[NSBundle mainBundle] pathForResource:@"aboutTiagol" ofType:@"m4a"];
    [self.player play:path];
    
    // this info shows up in the locked screen and control center
    MPNowPlayingInfoCenter* mpic = [MPNowPlayingInfoCenter defaultCenter];
    mpic.nowPlayingInfo = @{MPMediaItemPropertyArtist: @"Matt Neuburg",
                           MPMediaItemPropertyTitle: @"About Tiagol"};
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    UIEventSubtype rc = event.subtype;
    NSLog(@"got a remote event! %ld", (long)rc);
    if (rc == UIEventSubtypeRemoteControlTogglePlayPause) {
        if ([self.player.player isPlaying])
            [self.player.player stop];
        else
            [self.player.player play];
    } else if (rc == UIEventSubtypeRemoteControlPlay) {
        [self.player.player play];
    } else if (rc == UIEventSubtypeRemoteControlPause) {
        [self.player.player stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.player) {
        Player* p = [[Player alloc] init];
        self.player = p;
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}


@end
