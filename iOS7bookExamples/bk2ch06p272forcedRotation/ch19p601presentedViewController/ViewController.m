
#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController () <SecondViewControllerDelegate>

@end

@implementation ViewController

- (IBAction)doPresent:(id)sender {
    SecondViewController* svc = [SecondViewController new];
    svc.data = @"This is very important data!";
    svc.delegate = self;
    [self presentViewController: svc
                       animated:YES completion:nil];
}

- (void) acceptData:(id)data {
    // do something with the data here
    NSLog(@"%@", data);
}

-(NSUInteger)supportedInterfaceOrientations {
    NSLog(@"%@", @"presenter supported");
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewWillLayoutSubviews {
    NSLog(@"%@", @"presenter will layout");
}

@end
