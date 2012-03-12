

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MyMoviePlayerViewController.h"

@interface ViewController()
@property (nonatomic, strong) MPMoviePlayerController* mpc;
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation ViewController
@synthesize mpc, currentPop;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#define which 1 // try also 2

// just testing, pay no attention to this
- (void) stateChanged: (id) n {
    NSLog(@"%@", [[AVAudioSession sharedInstance] category]);
    if (self.mpc.playbackState == MPMoviePlaybackStatePlaying)
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    else
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
}

- (void)setUpMPC
{
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"movie2" withExtension:@"m4v"];
    //m = [[NSBundle mainBundle] URLForResource:@"wilhelm" withExtension:@"aiff"];
    MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:m];
    self.mpc = mp; // retain policy
    self.mpc.shouldAutoplay = NO;
    [self.mpc prepareToPlay]; // new requirement in iOS 5
    self.mpc.view.frame = CGRectMake(10, 10, 300, 250); // play with height
    self.mpc.backgroundView.backgroundColor = [UIColor redColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.mpc];
    switch (which) {
        case 1:
        {
            [self.view addSubview:self.mpc.view];
            //[self.mpc setFullscreen:YES];
            break;
        }
        case 2:
        {
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(finishSetup:) 
                                                         name:MPMovieNaturalSizeAvailableNotification 
                                                       object:self.mpc];
            break;
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    static BOOL done = NO;
    if (!done) {
        done = YES;
        [self setUpMPC];
    }
}

- (void) finishSetup: (id) n {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieNaturalSizeAvailableNotification object:self.mpc];
    CGRect f = self.mpc.view.bounds;
    f.size = self.mpc.naturalSize;
    // make width 300, keep ratio
    CGFloat ratio = 300.0/f.size.width;
    f.size.width *= ratio;
    f.size.height *= ratio;
    self.mpc.view.bounds = f;
    [self.view addSubview:self.mpc.view];
    //[self.mpc setFullscreen:YES animated:YES];
}

- (IBAction)doButton:(id)sender {
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"movie2" withExtension:@"m4v"];
    MPMoviePlayerViewController* mpvc = 
    [[MyMoviePlayerViewController alloc] initWithContentURL: m];
    [self presentMoviePlayerViewControllerAnimated:mpvc];
    mpvc.moviePlayer.initialPlaybackTime = 0;
    mpvc.moviePlayer.endPlaybackTime = 60 + 57;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void) vcFinished: (id) dummy {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    // try commenting this out and you'll see what the problem is:
    // There Can Be Only One
    // so after our MPMoviePlayerViewController, our MPMoviePlayerController's view is busted
    // to prevent that, we call prepareToPlay
    [self.mpc prepareToPlay];
}

// note: must run on device; no video editing in simulator

- (IBAction)doEditorButton:(id)sender {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"movie2" ofType:@"m4v"];
    BOOL can = [UIVideoEditorController canEditVideoAtPath:path];
    if (!can) {
        NSLog(@"can't edit this video");
        return;
    }
    UIVideoEditorController* vc = [[UIVideoEditorController alloc] init];
    vc.delegate = self;
    vc.videoPath = path;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // this is for demonstration only: the interface is *still* broken on iPad
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:vc];
        self.currentPop = pop;
        [pop presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    }
    else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mpc prepareToPlay];
    }];
}

-(void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    NSLog(@"%@", editedVideoPath);
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(editedVideoPath))
        UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, self, 
                                            @selector(video:savedWithError:ci:), 
                                            NULL);
    else
        NSLog(@"need to think of something else to do with it");
}

-(void)video:(NSString*)path savedWithError:(NSError*)err ci:(void*)ci {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mpc prepareToPlay];
    }];
}

-(void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    NSString* s = [error localizedDescription];
    NSLog(@"error: %@", s);
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mpc prepareToPlay];
    }];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
    //return YES;
    return io == UIInterfaceOrientationLandscapeRight;
}



@end
