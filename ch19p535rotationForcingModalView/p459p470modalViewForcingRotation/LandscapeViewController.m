
#import "LandscapeViewController.h"


@implementation LandscapeViewController


-(NSUInteger)supportedInterfaceOrientations {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait)
        return 0;
    return UIInterfaceOrientationMaskLandscape;
}


@end
