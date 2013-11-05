

#import "MyImagePickerController.h"

@interface MyImagePickerController ()

@end

@implementation MyImagePickerController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(UIViewController *)childViewControllerForStatusBarHidden {
    return nil;
}

@end
