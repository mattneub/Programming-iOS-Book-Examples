

#import "FirstViewController.h"
#import "ExtraViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
- (IBAction)doPresent:(id)sender {
    UIViewController* vc = [ExtraViewController new];
    
    // uncomment these lines to see the difference (on iPad only)
    // self.definesPresentationContext = YES;
//    self.parentViewController.definesPresentationContext = YES;
//    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // and then these (on iPad only)
//    self.providesPresentationContextTransitionStyle = YES;
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    // testing whether, using these styles, supported orientations is obeyed
//    vc.modalPresentationStyle = UIModalPresentationFormSheet; // no
//    vc.modalPresentationStyle = UIModalPresentationPageSheet; // no
    [self presentViewController:vc animated:YES completion:^{
        // logging to show the very weird situation for a fullscreen presented view controller
        // the presented view controller is the presented view controller of *two* vcs
        // and its presenting view controller is the root view, not self
        NSLog(@"%@", self.presentedViewController);
        NSLog(@"%@", self.presentedViewController.presentingViewController);
        NSLog(@"%@", self.presentedViewController.presentingViewController.presentedViewController);
    }];
}

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    NSLog(@"%@", @"dismiss");
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"speak" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"first vc's presented vc: %@", self.presentedViewController);
    }];
}
							

@end
