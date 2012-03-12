

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@end


@implementation RootViewController
@synthesize toolbar;


- (IBAction)doOtherThing:(id)sender {
    NSLog(@"imagine that this summons a popover");
}

- (IBAction)doButton:(id)sender {
    UIActionSheet* act = [[UIActionSheet alloc] 
                          initWithTitle:nil delegate:self cancelButtonTitle:nil 
                          destructiveButtonTitle:nil otherButtonTitles:@"Hey", @"Ho", nil];
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
