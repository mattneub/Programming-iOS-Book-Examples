

#import "PresentedViewController.h"

@interface PresentedViewController ()

@end

@implementation PresentedViewController

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSLog(@"%@ encode %@", self, coder);
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSLog(@"%@ decode %@", self, coder);
}

-(void)applicationFinishedRestoringState {
    NSLog(@"finished %@", self);
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load %@", self);
    self.view.backgroundColor = [UIColor blueColor];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Pop" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(doDismiss:)
     forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.backgroundColor = [UIColor whiteColor];
    button.center = self.view.center;
    [self.view addSubview:button];
}

-(void)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
