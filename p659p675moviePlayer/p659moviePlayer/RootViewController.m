

#import "RootViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation RootViewController
@synthesize mpc;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mpc release];
    [super dealloc];
}

#define which 1 // try also 2

- (void)setUpMPC
{
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"movie2" withExtension:@"m4v"];
    MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:m];
    self.mpc = mp; // retain policy
    [mp release];
    self.mpc.shouldAutoplay = NO;
    self.mpc.view.frame = CGRectMake(10, 10, 300, 230);
    self.mpc.backgroundView.backgroundColor = [UIColor redColor];
    switch (which) {
        case 1:
        {
            [self.view addSubview:self.mpc.view];
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
    CGFloat ratio = 300/f.size.width;
    f.size.width *= ratio;
    f.size.height *= ratio;
    self.mpc.view.bounds = f;
    [self.view addSubview:self.mpc.view];
}

- (IBAction)doButton:(id)sender {
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"movie2" withExtension:@"m4v"];
    MPMoviePlayerViewController* mpvc = 
    [[MPMoviePlayerViewController alloc] initWithContentURL: m];
    [self presentModalViewController:mpvc animated:YES];
    [mpvc release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void) startOverOnMPC {
    [self.mpc.view removeFromSuperview];
    [self setUpMPC];
}

- (void) vcFinished: (id) dummy {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    // try commenting this out and you'll see what the problem is:
    // There Can Be Only One
    // so after our MPMoviePlayerViewController, our MPMoviePlayerController's view is busted
    // to prevent that, we rip its view out of the interface and start over
    [self startOverOnMPC];
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
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

-(void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    [self dismissModalViewControllerAnimated:YES];
    // same issue as above, but also must add delay
    [self performSelector:@selector(startOverOnMPC) withObject:self afterDelay:0.5];
}

-(void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(editedVideoPath))
        UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, self, 
                                            @selector(video:savedWithError:ci:), 
                                            NULL);
    else
        NSLog(@"need to think of something else to do with it");
}

-(void)video:(NSString*)path savedWithError:(NSError*)err ci:(void*)ci {
    [self dismissModalViewControllerAnimated:YES];
    // same issue as above, but also must add delay
    [self performSelector:@selector(startOverOnMPC) withObject:self afterDelay:0.5];
}

-(void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    NSString* s = [error localizedDescription];
    NSLog(@"error: %@", s);
    [self dismissModalViewControllerAnimated:YES];
    // same issue as above, but also must add delay
    [self performSelector:@selector(startOverOnMPC) withObject:self afterDelay:0.5];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
    return io == UIInterfaceOrientationLandscapeRight;
}


@end
