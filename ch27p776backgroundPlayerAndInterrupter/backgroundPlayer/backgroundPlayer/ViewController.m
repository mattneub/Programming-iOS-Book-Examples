

#import "ViewController.h"
#import "Player.h"
#import <MediaPlayer/MediaPlayer.h>
#include <AVFoundation/AVFoundation.h>


@interface ViewController()
@property (nonatomic, strong) Player* player;
@end

@implementation ViewController

- (IBAction) doButton: (id) sender {
    // start playing from beginning
    NSString* path = [[NSBundle mainBundle] pathForResource:@"aboutTiagol" ofType:@"m4a"];
    [self.player play:path];
    
    // new iOS 5 feature
    // this info shows up in the locked screen and below the "multimedia" buttons
    MPNowPlayingInfoCenter* mpic = [MPNowPlayingInfoCenter defaultCenter];
    mpic.nowPlayingInfo = @{MPMediaItemPropertyArtist: @"Matt Neuburg",
                           MPMediaItemPropertyTitle: @"About Tiagol"};
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    UIEventSubtype rc = event.subtype;
    NSLog(@"got a remote event! %i", rc);
    if (rc == UIEventSubtypeRemoteControlPlay)
        [self.player.player play];
    else if (rc == UIEventSubtypeRemoteControlStop)
        [self.player.player stop];
    else if (rc == UIEventSubtypeRemoteControlTogglePlayPause) { // likeliest
        if ([self.player.player isPlaying])
            [self.player.player pause];
        else
            [self.player.player play];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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
