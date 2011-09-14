
#import "RootViewController.h"
#import "LandscapeViewController.h"

@implementation RootViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(io);
}

// cute hack to completely replace one interface with another on rotation, using a modal view

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(screenRotated:) 
                                                 name:UIDeviceOrientationDidChangeNotification 
                                               object:nil];
}

- (void) screenRotated: (id) notif {
    NSUInteger rot = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(rot) && !self.modalViewController) {
        [[UIApplication sharedApplication] setStatusBarOrientation:rot animated:YES];
        LandscapeViewController *c = [[LandscapeViewController alloc] init];
        c.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:c animated:YES];
        [c release];
    } else if (UIDeviceOrientationIsPortrait(rot) && self.modalViewController) {
        [[UIApplication sharedApplication] setStatusBarOrientation:rot animated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }
}


@end
