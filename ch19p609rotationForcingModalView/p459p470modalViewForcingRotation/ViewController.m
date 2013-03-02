
#import "ViewController.h"
#import "LandscapeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

-(NSUInteger)supportedInterfaceOrientations {
    return 0; // in iOS 6, must do this or status bar won't animate
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenRotated:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)screenRotated:(NSNotification *)n {
    UIDeviceOrientation rot = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(rot) & !self.presentedViewController) {
        NSLog(@"%@", @"landscape");
        [[UIApplication sharedApplication]
         setStatusBarOrientation:rot animated:YES];
        UIViewController* vc = [LandscapeViewController new];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    } else if (UIDeviceOrientationPortrait == rot) {
        NSLog(@"%@", @"portrait");
        [[UIApplication sharedApplication]
         setStatusBarOrientation:rot animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
