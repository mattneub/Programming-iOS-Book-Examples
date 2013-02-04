

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>


@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) IBOutlet UIView *redView;
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
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:type];
    if (!ok) {
        NSLog(@"alas");
        return;
    }
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.sourceType = type;
    picker.mediaTypes = @[(NSString*)kUTTypeImage];
    picker.delegate = self;
    picker.allowsEditing = YES;
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@", info);
    NSURL* url = info[UIImagePickerControllerMediaURL];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self dismissViewControllerAnimated:YES completion:^{
            [self dealWithInfo:info];
        }];
    else {
        [self.currentPop dismissPopoverAnimated:NO]; // must be NO, otherwise we hit the Only One rule
        self.currentPop = nil;
        if (url) {
            [self dealWithInfo:info];
        }
    }
}

- (void) dealWithInfo: (NSDictionary*) info {
    UIImage* im = nil;
    im = info[UIImagePickerControllerEditedImage];
    if (!im)
        im = info[UIImagePickerControllerOriginalImage];
    UIImageView* iv = [UIImageView new];
    iv.frame = self.redView.bounds;
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = im;
    while ([self.redView.subviews count])
        [self.redView.subviews[0] removeFromSuperview];
    [self.redView addSubview:iv];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.currentPop = nil;
}

// hmm, no longer crashes if app doesn't permit portrait

-(NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskLandscape;
}

@end
