

#import "ViewController.h"
@import MediaPlayer;
@import AVFoundation;
#import "MyMoviePlayerViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIVideoEditorControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) MPMoviePlayerController* mpc;
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation ViewController {
    BOOL _didInitialLayout;
}

-(void)willFullscreen: (id) n {
    // NSLog(@"%@", @"here");
    // self.mpc.fullscreen = NO; // failed experiment; I don't see how to prevent fullscreen mode
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskLandscape;
}

-(void)viewDidLayoutSubviews {
    if (!_didInitialLayout) {
        _didInitialLayout = YES;
        [self setUpMPC];
    }
}

- (void)setUpMPC
{
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"ElMirage" withExtension:@"mp4"];
    // m = [[NSBundle mainBundle] URLForResource:@"wilhelm" withExtension:@"aiff"];
    MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:m];
    self.mpc = mp; // retain policy
    self.mpc.shouldAutoplay = NO;
    [self.mpc prepareToPlay];
    self.mpc.view.frame = CGRectMake(10, 10, 300, 250); // play with height
    self.mpc.backgroundView.backgroundColor = [UIColor redColor];
    // self.mpc.controlStyle = MPMovieControlStyleFullscreen; // does work!
    
    [[NSNotificationCenter defaultCenter] addObserver:self
           selector:@selector(stateChanged:)
               name:MPMoviePlayerPlaybackStateDidChangeNotification
             object:self.mpc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willFullscreen:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:self.mpc];

    
#define which 2 // try 1 or 2
    
#if which == 1
    
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (self.mpc.readyForDisplay) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
            [self.view addSubview:self.mpc.view];
        }
    }];

#elif which == 2
    
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:MPMovieNaturalSizeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
        [self finishSetup];
    }];

#endif
    
}

- (void) finishSetup {
    NSLog(@"%@", @"here2");
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


// just testing, pay no attention to this
- (void) stateChanged: (id) n {
    NSLog(@"%@ %d", @"state changed", (int)[[n object] playbackState]);
    return;
    NSLog(@"%@", [[AVAudioSession sharedInstance] category]);
    if (self.mpc.playbackState == MPMoviePlaybackStatePlaying)
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    else
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
}

// ============================

- (IBAction)doButton:(id)sender {
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"ElMirage" withExtension:@"mp4"];
    MPMoviePlayerViewController* mpvc =
    [[MyMoviePlayerViewController alloc] initWithContentURL: m];
    // mpvc.moviePlayer.shouldAutoplay = NO;
    [self presentMoviePlayerViewControllerAnimated:mpvc];
    //    mpvc.moviePlayer.initialPlaybackTime = 0;
    //    mpvc.moviePlayer.endPlaybackTime = 60 + 57;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void) vcFinished: (id) n {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    NSLog(@"%@ %@", @"did finish", n);
    // try commenting this out and you'll see what the problem is:
    // There Can Be Only One
    // so after our MPMoviePlayerViewController, our MPMoviePlayerController's view is busted
    // to prevent that, we call prepareToPlay
    [self.mpc prepareToPlay];
}

// ===========================

// note: must run on device; no video editing in simulator

- (IBAction)doEditorButton:(id)sender {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ElMirage" ofType:@"mp4"];
    BOOL can = [UIVideoEditorController canEditVideoAtPath:path];
    if (!can) {
        NSLog(@"can't edit this video");
        return;
    }
    UIVideoEditorController* vc = [UIVideoEditorController new];
    vc.delegate = self;
    vc.videoPath = path;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // this is for demonstration only: the interface is *still* broken on iPad
        // says Choose Video, Use, etc.
        // but if you try to present the view controller full screen,
        // you get a crash 'On iPad, UIVideoEditorController must be presented via UIPopoverController'
//        [self presentViewController:vc animated:YES completion:nil];
//        return;
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:vc];
        pop.delegate = self;
        self.currentPop = pop;
        [pop presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}


-(void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    NSLog(@"saving to %@", editedVideoPath);
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(editedVideoPath))
        UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, self,
                                            @selector(video:savedWithError:ci:),
                                            nil);
    else
        NSLog(@"need to think of something else to do with it");
}

-(void)video:(NSString*)path savedWithError:(NSError*)err ci:(void*)ci {
    NSLog(@"did save %@", err);
    /*
     Important to check for error, because user can deny access
     to Photos library
     If that's the case, we will get error like this:
     Error Domain=ALAssetsLibraryErrorDomain Code=-3310 "Data unavailable" UserInfo=0x1d8355d0 {NSLocalizedRecoverySuggestion=Launch the Photos application, NSUnderlyingError=0x1d83d470 "Data unavailable", NSLocalizedDescription=Data unavailable}
     
     */
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    NSLog(@"%@", @"editor cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    NSString* s = [error localizedDescription];
    NSLog(@"error: %@", s);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"%@", @"popover dismissed");
    self.currentPop = nil;
}





@end
