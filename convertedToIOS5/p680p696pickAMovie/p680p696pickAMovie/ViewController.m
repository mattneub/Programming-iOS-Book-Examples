

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIView *redView;
@property (nonatomic, strong) MPMoviePlayerController* mpc;
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation ViewController
@synthesize redView, mpc, currentPop;

// run on device; universal
// you'll need to have a video file saved into the Camera Roll / Saved Photos album
// can use the p659moviePlayer example to set that up (edit embedded video and save it)

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
    picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self dismissViewControllerAnimated:YES completion:^{
            if (url)
                [self performSelector:@selector(showMovie:) withObject:url];
        }];
    else {
        [currentPop dismissPopoverAnimated:YES]; // or try NO if you hit the Only One rule
        [self performSelector:@selector(showMovie:) withObject:url];
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
    [self.mpc prepareToPlay];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mpc prepareToPlay];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.currentPop = nil;
    [self.mpc prepareToPlay];
}

@end
