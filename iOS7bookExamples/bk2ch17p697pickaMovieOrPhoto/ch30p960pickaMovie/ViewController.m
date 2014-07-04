
#import "ViewController.h"
@import MediaPlayer;
@import AssetsLibrary;
@import MobileCoreServices;
@import AVFoundation;

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@property (strong, nonatomic) MPMoviePlayerController* mpc;
@property (weak, nonatomic) IBOutlet UIView* redView;
@property (strong, nonatomic) UIPopoverController* currentPop;
@end

@implementation ViewController

- (IBAction)doPick:(id)sender {
    ALAuthorizationStatus stat = [ALAssetsLibrary authorizationStatus];
    if (stat == ALAuthorizationStatusDenied || stat == ALAuthorizationStatusRestricted) {
        NSLog(@"%@", @"No access");
        // return; // in this example, we can proceed anyway
    }
    
    UIImagePickerControllerSourceType src = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:src];
    if (!ok) {
        NSLog(@"alas");
        return;
    }
    
    NSArray* arr = [UIImagePickerController availableMediaTypesForSourceType:src];
    // NSLog(@"source types in library: %@", arr);
    
    [self.mpc pause]; // don't play behind picker
    
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.sourceType = src;
    picker.mediaTypes = arr;
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    
    // but really, it works just as well as a presented view controller on the iPad

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
    NSURL* url = info[UIImagePickerControllerMediaURL];
    UIImage* im = info[UIImagePickerControllerOriginalImage];
    UIImage* edim = info[UIImagePickerControllerEditedImage];
    if (edim)
        im = edim;
    
//    NSLog(@"%@", info[UIImagePickerControllerMediaURL]);
//    NSLog(@"%@", info[UIImagePickerControllerReferenceURL]);
    
    
    if (!self.currentPop) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    }
    NSString* type = info[UIImagePickerControllerMediaType];
    if ([type isEqualToString: (NSString*)kUTTypeImage] && im)
        [self showImage:im];
    else if ([type isEqualToString: (NSString*)kUTTypeMovie] && url)
        [self showMovie:url];
}

-(void)showImage:(UIImage*)im {
    UIImageView* v = [[UIImageView alloc] initWithImage:im];
    v.contentMode = UIViewContentModeScaleAspectFit;
    v.frame = self.redView.bounds;
    while ([self.redView.subviews count])
        [self.redView.subviews[0] removeFromSuperview];
    [self.redView addSubview:v];
}

-(void)showMovie:(NSURL*)url {
//    if (self.mpc) { // just playing around
//        AVPlayer* player = [[AVPlayer alloc] initWithURL:url];
//        AVPlayerLayer* layer = [[AVPlayerLayer alloc] init];
//        layer.player = player;
//        CGRect f = self.redView.frame;
//        layer.frame = CGRectOffset(f, f.size.width, 0);
//        [self.view.layer addSublayer:layer];
//        [player play];
//        return;
//    }
    MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.mpc = mp;
    self.mpc.view.frame = self.redView.bounds;
    self.mpc.backgroundView.backgroundColor = [UIColor redColor];
    while ([self.redView.subviews count])
        [self.redView.subviews[0] removeFromSuperview];
    [self.redView addSubview:self.mpc.view];
    [self.mpc prepareToPlay];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.currentPop = nil;
}


@end
