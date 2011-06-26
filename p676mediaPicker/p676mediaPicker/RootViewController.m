

#import "RootViewController.h"

@implementation RootViewController
@synthesize currentPop;

- (void)dealloc
{
    [currentPop release];
    [super dealloc];
}

// run on device
// this is also an example of a universal app
// one view controller (RootViewController), two nibs (RootView, RootView~ipad)
// the picker is a modal view on iPhone, a popover on iPad

- (void) presentPicker: (id) sender {
    MPMediaPickerController* picker = 
    [[[MPMediaPickerController alloc] init] autorelease];
    picker.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self presentModalViewController:picker animated:YES];
    else {
        UIPopoverController* pop = 
        [[UIPopoverController alloc] initWithContentViewController:picker];
        self.currentPop = pop;
        [pop presentPopoverFromBarButtonItem:sender
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [pop release];
    }
}

- (void) dismissPicker: (MPMediaPickerController*) mediaPicker {
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker 
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    MPMusicPlayerController* player = [MPMusicPlayerController applicationMusicPlayer];
    [player setQueueWithItemCollection:mediaItemCollection];
    [player play];
    [self dismissPicker: mediaPicker];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissPicker: mediaPicker];
}


- (IBAction)doGo:(id)sender {
    [self presentPicker: sender];
}

@end
