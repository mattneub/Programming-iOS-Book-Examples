

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
- (IBAction)doDismiss:(id)sender {
    NSLog(@"pvc %@", self.presentingViewController);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doPresent:(id)sender {
    // work out true presenter
    UIViewController* rvc = self.view.window.rootViewController;
    while (rvc.presentedViewController)
        rvc = rvc.presentedViewController;
    UIViewController* vc = [SecondViewController new];
    [rvc presentViewController:vc animated:YES completion:^{
        // NSLog(@"%@", vc.view.window.rootViewController);
        NSLog(@"pvc %@", vc.presentingViewController);
        NSLog(@"pvc.pvc %@", vc.presentingViewController.presentedViewController);
    }];
}


@end
