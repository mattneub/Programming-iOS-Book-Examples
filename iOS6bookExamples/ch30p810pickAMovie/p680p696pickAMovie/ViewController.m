

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>


@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) IBOutlet UIView *redView;
@property (nonatomic, strong) MPMoviePlayerController* mpc;
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation ViewController

// run on device; universal
// you'll need to have a video file saved into the Camera Roll / Saved Photos album
// if you don't have a camera...
// ...can use the p659moviePlayer example to set that up (edit embedded video and save it)

/*
 New iOS 6 feature: privacy settings on the photo album are separated from location privacy settings
 The *first* time, the user is asked for access when the picker appears
 If the user has denied access, then the *next* time,
 the picker contains the lock icon and message.
 But there is nothing new for *you* to do; your app gets no notification of what's happened,
 not can it modify any of that interface.
 */

/*
 Unfortunately, if the user does what the message suggests (switch to Settings and give permission),
 the app crashes in the background! I don't see how to prevent this, and have reported it as a bug.
 However, it is probably not a bug.
 */

/*
 New iOS 6 feature here: Info.plist contains a key you can use to appear in the alert message
 */



- (IBAction)doPick:(id)sender {
    // new iOS 6 feature: we can learn what our authorization status is...
    // ...but to do so, we must use ALAssetsLibrary
    ALAuthorizationStatus stat = [ALAssetsLibrary authorizationStatus];
    if (stat == ALAuthorizationStatusDenied || stat == ALAuthorizationStatusRestricted) {
        NSLog(@"%@", @"No access");
        // return; // in this example, we can proceed anyway
    }
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:type];
    if (!ok) {
        NSLog(@"alas");
        return;
    }
    [self.mpc pause]; // don't play behind picker
    
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.sourceType = type;
    picker.mediaTypes = @[(NSString*)kUTTypeVideo];
    picker.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self presentViewController:picker animated:YES completion:nil];
    else {
        UIPopoverController* pop = 
        [[UIPopoverController alloc] initWithContentViewController:picker];
        self.currentPop = pop;
        pop.delegate = self;
        [pop presentPopoverFromRect:[sender bounds] inView:sender
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

/* If there are no videos, the picker will appear...
 ...but with a No Videos message in it
 */

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL* url = info[UIImagePickerControllerMediaURL];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self dismissViewControllerAnimated:YES completion:^{
            if (url)
                [self showMovie:url];
        }];
    else {
        [self.currentPop dismissPopoverAnimated:NO]; // must be NO, otherwise we hit the Only One rule
        self.currentPop = nil;
        if (url) {
            [CATransaction setCompletionBlock:^{
                [self showMovie:url];
            }];
        }
    }
}

-(void)showMovie:(NSURL*)url {
    MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.mpc = mp;
    self.mpc.view.frame = self.redView.bounds;
    self.mpc.backgroundView.backgroundColor = [UIColor redColor];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        self.mpc.scalingMode = MPMovieScalingModeNone;
    while ([self.redView.subviews count])
        [self.redView.subviews[0] removeFromSuperview];
    [self.redView addSubview:self.mpc.view];
    // why isn't the slider appearing????
    // oh - it's because if the width is too narrow, the slider isn't shown!!!
    // fixed by rotating interface to landscape
    [self.mpc prepareToPlay];
    // NSLog(@"%@", self.redView.subviews);
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mpc prepareToPlay];
    }];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.currentPop = nil;
    [self.mpc prepareToPlay];
}

// hmm, no longer crashes if app doesn't permit portrait

-(NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskLandscape;
}

@end
