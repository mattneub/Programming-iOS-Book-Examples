

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// let's say the main interface prefers landscape

-(NSUInteger)supportedInterfaceOrientations {
    NSLog(@"1st supported");
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)doButton:(id)sender {
    UIViewController* vc = [SecondViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)viewWillLayoutSubviews {
    NSLog(@"%@", @"1st will layout");
}


@end
