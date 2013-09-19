

#import "RootViewController.h"
#import "Popover1View1.h"
#import "MyPopoverBackgroundView.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController () <UIPopoverControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation RootViewController {
    NSInteger _oldChoice;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(backgrounding:) 
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToPopover1"]) {
        UIStoryboardPopoverSegue* seg = (id)segue;
        UIPopoverController* pop = seg.popoverController;
        UINavigationController* nav = segue.destinationViewController;
        UIViewController* vc = nav.childViewControllers[0];
        nav.delegate = self;
        self.currentPop = pop;
        vc.title = @"Back"; // can't find a way to change Back button title successfully in storyboard
        [CATransaction setCompletionBlock:^{ pop.passthroughViews = nil; }];
        self->_oldChoice = [[NSUserDefaults standardUserDefaults] integerForKey:@"choice"];
        pop.delegate = self;
        // sheesh
        vc.navigationItem.leftBarButtonItem.target = self;
        vc.navigationItem.leftBarButtonItem.action = @selector(savePop1:);
        vc.navigationItem.rightBarButtonItem.target = self;
        vc.navigationItem.rightBarButtonItem.action = @selector(cancelPop1:);
        
    } else if ([segue.identifier isEqualToString:@"ToPopover2"]) {
        UIStoryboardPopoverSegue* seg = (id)segue;
        UIPopoverController* pop = seg.popoverController;
        UIViewController* vc = segue.destinationViewController;
        UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [vc.view addGestureRecognizer:t];
        pop.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 40);
        pop.popoverBackgroundViewClass = [MyPopoverBackgroundView class];
        self.currentPop = pop;
        [CATransaction setCompletionBlock:^{ pop.passthroughViews = nil; }];
        pop.delegate = self;
    }
}

// deal with content size change bug
- (void)navigationController:(UINavigationController *)navigationController 
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated { 
    navigationController.contentSizeForViewInPopover = viewController.contentSizeForViewInPopover;
}

// what to do when first popover is dismissed

- (void) cancelPop1: (id) sender {
    // dismiss popover and revert choice
    NSLog(@"%@", @"here1");
    [CATransaction setCompletionBlock:^{
        NSLog(@"%@", @"here2");
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", @"here3");
    });
    [self.currentPop dismissPopoverAnimated:YES];
    self.currentPop = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:self->_oldChoice forKey:@"choice"];
}

- (void) savePop1: (id) sender {
    // dismiss popover and don't revert choice
    [self.currentPop dismissPopoverAnimated:YES];
    self.currentPop = nil;
}

// but there is a third possibility: the user taps outside the popover and it dismisses itself
// this is equivalent to a cancel, in my implementation
// however (and this is the really annoying part) if we are also the second popover's delegate...
// we will get this message as well
// so we have to test for which popover this is
// that's not so easy! in this case we can use the content view controller type...
// ...but in some implementations you might need to provide some other means of identification

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)pc { 
    if ([pc.contentViewController isKindOfClass: [UINavigationController class]])
        [[NSUserDefaults standardUserDefaults] setInteger:self->_oldChoice forKey:@"choice"];
    self.currentPop = nil;
}

// test modality of presented view controller inside popover

- (void) tapped: (UIGestureRecognizer*) g {
    [(UIViewController*)[g.view nextResponder] performSegueWithIdentifier:@"ToPresentedView" sender:self];
}

// I'd rather not have popovers showing thru rotation
// this dismissal counts as a cancel
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIPopoverController* pc = self.currentPop;
    if (pc) {
        if ([pc.contentViewController isKindOfClass: [UINavigationController class]])
            [[NSUserDefaults standardUserDefaults] setInteger:self->_oldChoice forKey:@"choice"];
        [pc dismissPopoverAnimated:NO];
        self.currentPop = nil; // wrong in previous version
    }
}

// notification from system; I'd rather not have popovers standing during background state
// this dismissal counts as a cancel
-(void)backgrounding:(id)dummy {
    UIPopoverController* pc = self.currentPop;
    if (pc) {
        if ([pc.contentViewController isKindOfClass: [UINavigationController class]])
            [[NSUserDefaults standardUserDefaults] setInteger:self->_oldChoice forKey:@"choice"];
        [pc dismissPopoverAnimated:NO];
        self.currentPop = nil; // wrong in previous version
    }
}

// was that messy or what?????
// but I don't see a better way, in the absence of decent built-in popover management
// and of course if this app had more popovers it could get even messier!

@end
