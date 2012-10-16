
#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (IBAction)doButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#define which 1 // and try "2" to illustrated "preferred..."

#if (which==1)

-(NSUInteger)supportedInterfaceOrientations {
    NSLog(@"2nd supported");
    return UIInterfaceOrientationMaskPortrait;
}

#endif

/*
 That's all it takes.
 So what is preferredInterfaceOrientationForPresentation for?
 It's so that the presented view can express a preference among *multiple* supported orientations...
 ...for the one that it likes *best* when it *initially* appears.
 */

#if (which==2)

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


#endif


@end
