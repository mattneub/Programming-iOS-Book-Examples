

#import "ViewController.h"
#import "Player.h"

@interface ViewController()
@property (nonatomic, strong) Player* player;
@end

@implementation ViewController
@synthesize player;

- (IBAction) doButton: (id) sender {
    // start playing from beginning
    NSString* path = [[NSBundle mainBundle] pathForResource:@"aboutTiagol" ofType:@"m4a"];
    [self.player play:path];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    UIEventSubtype rc = event.subtype;
    NSLog(@"hey, I got a remote event! %i", rc);
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
