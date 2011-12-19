

#import "ViewController.h"
#import "LandscapeViewController.h"

@implementation ViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    // Return YES for supported orientations
    return io == UIInterfaceOrientationPortrait;
}

// cute hack to completely replace one interface with another on rotation, using a modal view
// but the example was always hacky, and now it's showing some odd quirks, so I might cut it

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
    if (UIDeviceOrientationIsLandscape(rot) && !self.presentedViewController) {
//        NSLog(@"one");
        [[UIApplication sharedApplication] setStatusBarOrientation:rot animated:YES];
        LandscapeViewController *c = [[LandscapeViewController alloc] init];
        c.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:c animated:YES completion:nil];
    } else if (rot==UIDeviceOrientationPortrait && self.presentedViewController) {
//        NSLog(@"two %i", rot);
        [[UIApplication sharedApplication] setStatusBarOrientation:rot animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
