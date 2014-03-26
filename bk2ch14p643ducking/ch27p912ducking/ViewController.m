


#import "ViewController.h"
#import "Player.h"
@import AVFoundation;

@interface ViewController ()
@property (nonatomic, retain) Player* player;
@end

@implementation ViewController

-(void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unduck:) name:@"soundFinished" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    }
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"aif"];
    if ([[(UIButton*)sender currentTitle] isEqualToString:@"Forever"]) {
        // for remote control to work, our audio session policy must be Playback
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback withOptions: 0 error: nil];
        self.player.forever = YES;
    }
    else {
        // example works better if there is some background audio already playing
        BOOL oth = ((AVAudioSession*)[AVAudioSession sharedInstance]).otherAudioPlaying;
        if (!oth) {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"Pointless" message:@"You won't get the point of the example unless some other audio is already playing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [v show];
            return;
        }
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient
                                         withOptions: AVAudioSessionCategoryOptionDuckOthers
                                               error: nil];
        self.player.forever = NO;
    }
    [self.player play:path];
}

- (void) unduck: (id) dummy {
    [[AVAudioSession sharedInstance] setActive:NO withOptions:0 error:nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient
                                     withOptions: 0
                                           error: nil];
    [[AVAudioSession sharedInstance] setActive:YES withOptions: 0 error:nil];
    
}

// =========== respond to remote controls

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    // return;
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    NSLog(@"received remote control %ld", (long)event.subtype);
    UIEventSubtype rc = event.subtype;
    // but in iOS 7 we no longer get this
    if (rc == UIEventSubtypeRemoteControlTogglePlayPause) {
        if ([self.player.player isPlaying])
            [self.player.player stop];
        else
            [self.player.player play];
    // this is what you have to do in iOS 7
    } else if (rc == UIEventSubtypeRemoteControlPlay) {
        [self.player.player play];
    } else if (rc == UIEventSubtypeRemoteControlPause) {
        [self.player.player stop];
    }
}

@end
