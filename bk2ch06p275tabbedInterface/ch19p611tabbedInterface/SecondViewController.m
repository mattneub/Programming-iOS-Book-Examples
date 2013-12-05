

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

-(NSUInteger)supportedInterfaceOrientations {
    NSLog(@"%@", @"here");
    return UIInterfaceOrientationMaskLandscape; // pointless
}

@end
