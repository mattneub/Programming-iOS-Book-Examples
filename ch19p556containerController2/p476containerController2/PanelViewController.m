

#import "PanelViewController.h"
#import "ModalViewController.h"

@implementation PanelViewController

- (IBAction)doModal1:(id)sender {
    // You couldn't do *this* little trick before iOS 5! Wow!
    self.definesPresentationContext = YES;
    self.providesPresentationContextTransitionStyle = YES;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    ModalViewController* m = [[ModalViewController alloc] init];
    [self presentViewController:m animated:YES completion:nil];
    
    // note that the view presented in this way is not really "modal"
    // you can still press the Dummy button in the interface even when it is showing
    // this is a terminology problem for Apple, since the key setting is still the modalPresentationStyle
    
    // I've made this a universal app so you can see that this *doesn't* work on iPhone
    // I believe this is because the key line
    // self.modalPresentationStyle = UIModalPresentationCurrentContext
    // effectively does nothing on iPhone
}

- (IBAction)doModal2:(id)sender {
    // this way, it's just like before iOS 5
    self.definesPresentationContext = NO;
    ModalViewController* m = [[ModalViewController alloc] init];
    [self presentViewController:m animated:YES completion:nil];
}


@end
