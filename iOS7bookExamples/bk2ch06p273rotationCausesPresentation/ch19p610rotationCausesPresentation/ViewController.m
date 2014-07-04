

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(NSUInteger)supportedInterfaceOrientations {
    return 0;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(screenRotated:)
     name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)screenRotated:(NSNotification *)n {
    UIDeviceOrientation r = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation r2 = (UIInterfaceOrientation)r;
    if (UIDeviceOrientationIsLandscape(r) & !self.presentedViewController) {
        [[UIApplication sharedApplication]
         setStatusBarOrientation:r2 animated:YES];
        UIViewController* vc = [SecondViewController new];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    } else if (UIDeviceOrientationPortrait == r) {
        [[UIApplication sharedApplication]
         setStatusBarOrientation:r2 animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
