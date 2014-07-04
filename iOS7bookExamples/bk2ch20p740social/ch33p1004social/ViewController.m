

#import "ViewController.h"
@import MessageUI;
@import Social;

@interface ViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (IBAction)doMail:(id)sender {
    BOOL ok = [MFMailComposeViewController canSendMail];
    if (!ok) return;
    MFMailComposeViewController* vc = [MFMailComposeViewController new];
    vc.mailComposeDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"mail result %d", result);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doMessage:(id)sender {
    BOOL ok = [MFMessageComposeViewController canSendText];
    if (!ok) return;
    MFMessageComposeViewController* vc = [MFMessageComposeViewController new];
    vc.messageComposeDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    NSLog(@"message result %d", result);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doTwitter:(id)sender {
    BOOL ok = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    if (!ok) return;
    SLComposeViewController* vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (!vc) return;
    vc.completionHandler = ^(SLComposeViewControllerResult result) {
        NSLog(@"tweet result %ld", (long)result);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:vc animated:YES completion:nil];
}


@end
