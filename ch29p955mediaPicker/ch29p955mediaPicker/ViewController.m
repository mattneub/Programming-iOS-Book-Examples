

#import "ViewController.h"
@import MediaPlayer;

@interface ViewController () <MPMediaPickerControllerDelegate, UIPopoverControllerDelegate, UIToolbarDelegate>
@property (nonatomic, strong) UIPopoverController* currentPop;
@property (nonatomic, weak) IBOutlet UIToolbar* toolbar;
@end

@implementation ViewController

// run on device
// this is also an example of a universal app
// the picker is a presented view on iPhone, a popover on iPad

- (void) viewDidLoad {
    [super viewDidLoad];
    self.toolbar.delegate = self;
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (IBAction) doGo: (id) sender {
    [self presentPicker:sender];
}

- (void) presentPicker: (id) sender {
    MPMediaPickerController* picker =
    [MPMediaPickerController new];
    // code works just as well if you uncomment next line
    // picker.allowsPickingMultipleItems = YES;
    picker.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self presentViewController:picker animated:YES completion:nil];
    else {
        // does also work great as a presented controller; uncomment next two lines and see
//        [self presentViewController:picker animated:YES completion:nil];
//        return;
        UIPopoverController* pop =
        [[UIPopoverController alloc] initWithContentViewController:picker];
        self.currentPop = pop;
        pop.popoverContentSize = CGSizeMake(500,600);
        [pop presentPopoverFromBarButtonItem:sender
                    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        pop.passthroughViews = nil;
    }
}

- (void) dismissPicker: (MPMediaPickerController*) mediaPicker {
    if (self.currentPop && self.currentPop.popoverVisible) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.currentPop = nil;
}


@end
