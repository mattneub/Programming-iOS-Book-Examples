

#import "RootViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation RootViewController
@synthesize redView, mpc, currentPop;

- (void)dealloc
{
    [redView release];
    [mpc release];
    [currentPop release];
    [super dealloc];
}

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
    [self.mpc.view removeFromSuperview]; // There Can Be Only One
    [self.mpc stop];
    self.mpc = nil;
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
    picker.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self presentModalViewController:picker animated:YES];
    else {
        UIPopoverController* pop = 
        [[UIPopoverController alloc] initWithContentViewController:picker];
        self.currentPop = pop;
        [pop presentPopoverFromRect:[sender bounds] inView:sender
                    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [pop release];
    }
    [picker release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];
    if (url) {
        // delayed performance is crucial here;
        // can't show the movie elsewhere in the interface until the picker is completely gone
        // There Can Be Only One
        [self performSelector:@selector(showMovie:) withObject:url afterDelay:0.5];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self dismissModalViewControllerAnimated:YES];
    else {
        [currentPop dismissPopoverAnimated:YES];
    }
}

-(void)showMovie:(NSURL*)url {
    self.currentPop = nil;
    MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.mpc = mp;
    self.mpc.view.frame = self.redView.bounds;
    self.mpc.backgroundView.backgroundColor = [UIColor redColor];
    [self.redView addSubview:self.mpc.view];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

@end
