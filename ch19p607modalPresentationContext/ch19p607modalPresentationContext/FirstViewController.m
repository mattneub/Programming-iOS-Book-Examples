

#import "FirstViewController.h"
#import "ExtraViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (IBAction)doPresent:(id)sender {
    
#define which 3
    
#if which == 1
    
    UIViewController* vc = [ExtraViewController new];
    [self presentViewController:vc animated:YES completion:nil];
    
#elif which == 2
    
    UIViewController* vc = [ExtraViewController new];
    self.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
    
#elif which == 3
    
    UIViewController* vc = [ExtraViewController new];
    self.definesPresentationContext = YES;
    self.providesPresentationContextTransitionStyle = YES;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical; // this will be overridden
    [self presentViewController:vc animated:YES completion:nil];

#endif
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
