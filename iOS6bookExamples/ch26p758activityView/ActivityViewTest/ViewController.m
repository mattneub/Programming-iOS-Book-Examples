

#import "ViewController.h"
#import "MyCoolActivity.h"
#import "MyElaborateActivity.h"

@interface ViewController () <UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation ViewController

- (UIActivityViewController*) avc {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"sunglasses" withExtension:@"png"];
    UIActivityViewController* avc = [[UIActivityViewController alloc] initWithActivityItems:@[@"This is cool", url] applicationActivities:@[[MyCoolActivity new], [MyElaborateActivity new]]];
    avc.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSLog(@"activity %@ completed:%i", activityType, completed);
    };
    avc.excludedActivityTypes = @[
                                  UIActivityTypePostToFacebook,
                                  UIActivityTypePostToTwitter,
                                  UIActivityTypePostToWeibo,
                                  UIActivityTypeMessage,
                                  UIActivityTypeMail,
                                  UIActivityTypePrint,
                                  UIActivityTypeCopyToPasteboard,
                                  UIActivityTypeAssignToContact,
                                  UIActivityTypeSaveToCameraRoll
                                  ];
    // avc.excludedActivityTypes = nil;
    return avc;
}

- (IBAction)doButton:(id)sender {
    [self presentViewController:[self avc] animated:YES completion:nil];
}

- (IBAction)doButtoniPad:(id)sender {
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:[self avc]];
    self.currentPop = pop;
    pop.delegate = self;
    [pop presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    pop.passthroughViews = nil;

}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"%@", @"popover dismissed"); // never received if user picks an activity!
    self.currentPop = nil;
}

- (IBAction)doOtherButton:(id)sender {
    NSLog(@"%@", @"here");
}

@end
