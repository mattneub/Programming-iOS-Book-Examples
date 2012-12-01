

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>


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
 New iOS 6 feature: privacy settings on the photo album
 The *first* time, the user is asked for access when the picker appears
 If the user has denied access, then the *next* time,
 the picker contains the lock icon and message.
 But there is nothing new for *you* to do; your app gets no notification of what's happened,
 not can it modify any of that interface.
 */

/*
 Unfortunately, if the user does what the message suggests (switch to Settings and give permission),
 the app crashes in the background! I don't see how to prevent this, and have reported it as a bug.
 */

- (IBAction)doPick:(id)sender {
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:type];
    if (!ok) {
        NSLog(@"alas");
        return;
    }
    [self.mpc pause]; // don't play behind picker
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    picker.mediaTypes = @[(NSString*)kUTTypeMovie];
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
        if (url)
            [self showMovie:url];
    }
}

-(void)showMovie:(NSURL*)url {
    self.currentPop = nil; // There Can Be Only One
    MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.mpc = mp;
    self.mpc.view.frame = self.redView.bounds;
    self.mpc.backgroundView.backgroundColor = [UIColor redColor];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        self.mpc.scalingMode = MPMovieScalingModeNone;
    [self.redView addSubview:self.mpc.view];
    // why isn't the slider appearing????
    // oh - it's because if the width is too narrow, the slider isn't shown!!!
    // fixed by rotating interface to landscape
    [self.mpc prepareToPlay];

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

// good example of conflicting orientations;
// the picker *requires* portrait, so our app must allow portrait or we'll crash showing the picker
// therefore we do allow it, and we filter it out here

-(NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end
