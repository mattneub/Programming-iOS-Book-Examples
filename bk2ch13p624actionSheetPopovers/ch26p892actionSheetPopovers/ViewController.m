

#import "ViewController.h"
#import "PopoverViewController.h"
#import "AppDelegate.h"

@interface ViewController () <UIToolbarDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.toolbar.delegate = self;
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (IBAction)doButton:(id)sender {
    UIActionSheet* act = [[UIActionSheet alloc]
                          initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" // not shown
                          destructiveButtonTitle:nil otherButtonTitles:@"Hey", @"Ho", @"Hey Nonny No", nil];
    [act showFromBarButtonItem:sender animated:YES];
    //[act showInView:self.view];
}

// without this stuff, the toolbar buttons would be active while the action sheet popover is up
// comment them out and see
// however, the fact that this is necessary seems like a huge bug to me


- (void)didPresentActionSheet:(UIActionSheet *)actionSheet {
    [self.toolbar setUserInteractionEnabled:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.toolbar setUserInteractionEnabled:YES];
    NSLog(@"pressed %ld %ld", (long)buttonIndex, (long)actionSheet.cancelButtonIndex);
}

// ========================

- (IBAction)doOtherThing:(id)sender {
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:[PopoverViewController new]];
    pop.delegate = self;
    APPDEL.currentPop = pop;
    [pop presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    pop.passthroughViews = nil;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"%@", @"popover dismissed");
    APPDEL.currentPop = nil;
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet {
    NSLog(@"%@", @"here"); // never called
}



@end
