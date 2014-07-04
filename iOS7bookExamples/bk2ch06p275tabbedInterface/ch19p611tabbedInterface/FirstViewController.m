

#import "FirstViewController.h"

@interface FirstViewController () <UITabBarControllerDelegate>

@end

@implementation FirstViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self; // new iOS 7 delegate feature...
    // delegate gets to dictate rotation rules
}

-(NSUInteger)tabBarControllerSupportedInterfaceOrientations: (UITabBarController *) tabBarController {
    return UIInterfaceOrientationMaskPortrait;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait; // pointless
}


@end
