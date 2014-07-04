

#import "ViewController.h"
#import "MyCoolActivity.h"
#import "MyElaborateActivity.h"

@interface ViewController () <UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation ViewController

- (UIActivityViewController*) avc {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"sunglasses" withExtension:@"png"];
    NSArray* things = @[@"This is cool", url];
    UIActivityViewController* avc = [[UIActivityViewController alloc] initWithActivityItems:things applicationActivities:nil];
    avc = [[UIActivityViewController alloc] initWithActivityItems:@[@"This is cool", url] applicationActivities:@[[MyCoolActivity new], [MyElaborateActivity new]]];
    avc.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSLog(@"activity %@ completed:%d", activityType, completed);
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self doButtoniPad:sender];
    else
        [self presentViewController:[self avc] animated:YES completion:nil];
}

- (void)doButtoniPad:(id)sender {
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:[self avc]];
    self.currentPop = pop;
    pop.delegate = self;
    [pop presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    pop.passthroughViews = nil;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"%@", @"popover dismissed");
    self.currentPop = nil;
}


@end
