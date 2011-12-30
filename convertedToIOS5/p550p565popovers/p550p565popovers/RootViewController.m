

#import "RootViewController.h"
#import "Popover1View1.h"
#import "MyPopoverBackgroundView.h"

@interface RootViewController ()
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation RootViewController {
    NSInteger oldChoice;
}

@synthesize currentPop;


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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)doPopover1:(id)sender {
    Popover1View1* vc = [[Popover1View1 alloc] initWithNibName:@"Popover1View1" bundle:nil];
    UIBarButtonItem* b = [[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self
                          action: @selector(cancelPop1:)]; 
    vc.navigationItem.rightBarButtonItem = b;
    b = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem: UIBarButtonSystemItemDone
         target: self
         action: @selector(savePop1:)]; 
    vc.navigationItem.leftBarButtonItem = b;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:nav];
    // comment out next line and you'll see the bug when navigating back and forth between different sized content views
    // [iOS 5] bug still present in iOS 5
    nav.delegate = self;
    self.currentPop = pop;
    //pop.popoverLayoutMargins = UIEdgeInsetsMake(0,100,100,100);
    [pop presentPopoverFromBarButtonItem:sender 
                permittedArrowDirections:UIPopoverArrowDirectionAny 
                                animated:YES];
    // comment out next line and you'll see that Bad Things can happen
    // can summmon same popover twice
    // also note that this line must come *after* we present the popover or it is ineffectual
    // [iOS 5] all of that is still true, except that instead of summoning same popover twice,
    // we now crash if next line is commented out when tapping button with popover showing
    // this is because as we assign a new popover controller to currentPop...
    // ...the previous popover controller is dealloced while its popover is showing,
    // which is illegal (sort of nice, really)
    pop.passthroughViews = nil;
    // this is a popover where the user can make changes but then cancel them
    // thus we need to preserve the current values in case we have to revert (cancel) later
    self->oldChoice = [[NSUserDefaults standardUserDefaults] integerForKey:@"choice"];
    // make ourselves delegate so we learn when popover is dismissed
    pop.delegate = self;
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
    [self.currentPop dismissPopoverAnimated:YES];
    self.currentPop = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:self->oldChoice forKey:@"choice"];
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
        [[NSUserDefaults standardUserDefaults] setInteger:self->oldChoice forKey:@"choice"];
    self.currentPop = nil;
}


// second popover, just a dummy

- (IBAction)doPopover2:(id)sender {
    UIViewController* vc = [[UIViewController alloc] init];
    vc.view.frame = CGRectMake(0,0,300,300);
    vc.view.backgroundColor = [UIColor greenColor];
    vc.contentSizeForViewInPopover = CGSizeMake(300,300);
    UILabel* label = [[UILabel alloc] init];
    label.text = @"I am a very silly popover!";
    [label sizeToFit];
    label.center = CGPointMake(150,150);
    label.frame = CGRectIntegral(label.frame);
    [vc.view addSubview: label];
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [vc.view addGestureRecognizer:t];
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:vc];
    // pop.popoverContentSize = vc.view.frame.size;
    // new iOS 5 feature: we can force the popover further from the edge of the screen
    // silly example: just a little extra space at this popover's right
    pop.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 40);
    // another new iOS 5 feature: we can supply the background view!
    pop.popoverBackgroundViewClass = [MyPopoverBackgroundView class];
    self.currentPop = pop;
    [pop presentPopoverFromBarButtonItem:sender 
                permittedArrowDirections:UIPopoverArrowDirectionAny 
                                animated:YES];
    pop.passthroughViews = nil;
    pop.delegate = self;
}

// test modality of presented view controller inside popover

- (void) tapped: (UIGestureRecognizer*) g {
    UIViewController* vc = [[UIViewController alloc] init];
    vc.view.frame = CGRectMake(0,0,300,300);
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.contentSizeForViewInPopover = vc.view.frame.size;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    vc.modalInPopover = NO; // no result; it gets set again later to YES
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setTitle:@"Done" forState:UIControlStateNormal];
    [b sizeToFit];
    b.center = CGPointMake(150,150);
    b.frame = CGRectIntegral(b.frame);
    b.autoresizingMask = UIViewAutoresizingNone;
    [b addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside]; 
    [vc.view addSubview:b];
    // uncomment next line if you'd like to crash
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UIViewController* presenter = (UIViewController*)[g.view nextResponder];
    [presenter presentViewController:vc animated:YES completion:nil];
    // uncomment next line and we'll be non-modal, but you shouldn't
    // vc.modalInPopover = NO;
}

- (void) done: (UIButton*) sender {
    UIResponder* r = sender;
    while (![r isKindOfClass: [UIViewController class]])
        r = [r nextResponder];
    [(UIViewController*)r dismissViewControllerAnimated:YES completion:nil];
}

// I'd rather not have popovers showing thru rotation
// this dismissal counts as a cancel
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIPopoverController* pc = self.currentPop;
    if (pc) {
        if ([pc.contentViewController isKindOfClass: [UINavigationController class]])
            [[NSUserDefaults standardUserDefaults] setInteger:self->oldChoice forKey:@"choice"];
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
            [[NSUserDefaults standardUserDefaults] setInteger:self->oldChoice forKey:@"choice"];
        [pc dismissPopoverAnimated:NO];
        self.currentPop = nil; // wrong in previous version
    }
}

// was that messy or what?????
// but I don't see a better way, in the absence of decent built-in popover management
// and of course if this app had more popovers it could get even messier!

@end
