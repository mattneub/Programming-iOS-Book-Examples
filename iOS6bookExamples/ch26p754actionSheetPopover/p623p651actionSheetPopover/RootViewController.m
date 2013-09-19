

#import "RootViewController.h"
#import "PopoverViewController.h"
#import "AppDelegate.h"

@interface RootViewController () <UIActionSheetDelegate, UIPopoverControllerDelegate>
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation RootViewController


- (IBAction)doOtherThing:(id)sender {
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:[PopoverViewController new]];
    pop.popoverContentSize = CGSizeMake(320,400);
    pop.delegate = self;
    APPDEL.currentPop = pop;
    [pop presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"%@", @"popover dismissed");
    APPDEL.currentPop = nil;
}

- (IBAction)doButton:(id)sender {
    UIActionSheet* act = [[UIActionSheet alloc] 
                          initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil otherButtonTitles:@"Hey", @"Ho", @"Hey Nonny No", nil];
    [act showFromBarButtonItem:sender animated:YES];
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
    NSLog(@"pressed %i", buttonIndex);
}
 
 

@end
