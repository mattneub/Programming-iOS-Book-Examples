

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIPopoverController* currentPop;
@end

// proving that modalInPopover is overridden by the passthroughViews
// both previous editions of the book, and the docs, have this wrong
// I don't know whether this changed or I was wrong all along, sorry

@implementation ViewController
- (IBAction)doButton:(id)sender {
    if (self.currentPop) {
        [self.currentPop dismissPopoverAnimated:YES];
        self.currentPop = nil;
        return;
    }
    UIViewController* vc = [UIViewController new];
    vc.contentSizeForViewInPopover = CGSizeMake(100,100);
    vc.modalInPopover = YES;
    UIPopoverController* pc = [[UIPopoverController alloc] initWithContentViewController:vc];
    [pc presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    pc.passthroughViews = @[sender];
    self.currentPop = pc;
    vc.modalInPopover = YES; // trying a second time, really really please be modal

}


@end
