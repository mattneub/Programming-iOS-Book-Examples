
#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController () <SecondViewControllerDelegate>

@end

@implementation ViewController

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@", @"vc did disappear");
}

- (IBAction)doPresent:(id)sender {
    SecondViewController* svc = [SecondViewController new];
    svc.data = @"This is very important data!";
    svc.delegate = self;
    
#define which 2
    
#if which == 1
    
    svc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
#elif which == 2
    
    svc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.view.window.backgroundColor = [UIColor greenColor]; // prove it shows
    
#endif
    
    [self presentViewController: svc
                       animated:YES completion:nil];
}

- (void) acceptData:(id)data {
    // do something with the data here
    NSLog(@"%@", data);
}

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    NSLog(@"%@", @"here"); // prove that this is called by clicking on curl
    [super dismissViewControllerAnimated:flag completion:completion];
}

@end
