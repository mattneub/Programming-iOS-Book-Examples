
#import "ViewController.h"
#import "LandscapeViewController.h"

@implementation ViewController

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
    if (UIDeviceOrientationIsLandscape(rot) && !self.presentedViewController) {
        UIViewController* vc = [LandscapeViewController new];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if ((UIDeviceOrientationPortrait == rot) && self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// explicitly rotating the status bar no longer works to trigger rotation animation
// however, this is still a valuable technique, and the dissolve sort of covers the issue

@end
