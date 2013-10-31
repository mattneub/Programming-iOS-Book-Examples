

#import "PopoverViewController.h"
#import "AppDelegate.h"

@interface PopoverViewController () <UIActionSheetDelegate>
@property (nonatomic, strong) NSArray* oldPassthroughViews;
@end

@implementation PopoverViewController

-(CGSize)preferredContentSize {
    return CGSizeMake(320,230);
}

- (IBAction)showOptions:(id)sender {
    UIActionSheet* act = [[UIActionSheet alloc]
                          initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil otherButtonTitles:@"Hey", @"Ho", @"Hey Nonny No", nil];
    [act showInView:self.view];
    self.oldPassthroughViews = APPDEL.currentPop.passthroughViews;
    APPDEL.currentPop.passthroughViews = nil;
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    APPDEL.currentPop.passthroughViews = self.oldPassthroughViews;
}



@end
