
#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

-(NSUInteger)supportedInterfaceOrientations {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait)
        return 0;
    return UIInterfaceOrientationMaskLandscape;
}


@end
