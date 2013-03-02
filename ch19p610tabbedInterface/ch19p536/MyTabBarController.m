

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

/*
 
 The big change in iOS 6 is that you *do* subclass UITabBarController
 if you want custom rotation. We no longer consult the child view controllers;
 by default, UITabBarController supports all rotations.
 So to support fewer rotations, you need to subclass.
 
 */

-(NSUInteger)supportedInterfaceOrientations {
    // return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}

@end
