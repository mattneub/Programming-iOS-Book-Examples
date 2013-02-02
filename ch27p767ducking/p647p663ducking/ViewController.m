

#import "ViewController.h"
#import "Player.h"

@interface ViewController ()
@property (nonatomic, retain) Player* player;
@end

@implementation ViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unduck:) name:@"soundFinished" object:nil];
    }
    return self;
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
        // new in iOS 6, we now have (gasp) audio session properties!
        BOOL oth = ((AVAudioSession*)[AVAudioSession sharedInstance]).otherAudioPlaying;
        if (!oth) {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"Pointless" message:@"You won't get the point of the example unless some other audio is already playing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [v show];
            return;
        }
        // new call in iOS 6
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient
                                         withOptions: AVAudioSessionCategoryOptionDuckOthers
                                               error: nil];
        self.player.forever = NO;
    }
    [self.player play:path];
}

- (void) unduck: (id) dummy {
//    UInt32 duck = 0;
//    AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, 
//                            sizeof(duck), &duck);
//    AudioSessionSetActive(false);
//    AudioSessionSetActive(true);
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
    //return;
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
