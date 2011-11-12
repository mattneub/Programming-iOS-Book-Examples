

#import "RootViewController.h"
#import "Popover1View1.h"
#import "MyPopoverBackgroundView.h"

@implementation RootViewController {
    NSInteger oldChoice;
}

// Exactly the same as existing example except I use storyboard for first popover's controller
// This shows how you can dive into a storyboard and grab a view controller at any time

@synthesize currentPop;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(backgrounding:) 
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)dealloc // notifications can still require use of dealloc under ARC, but no call to super
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)doPopover1:(id)sender {
    [self becomeFirstResponder]; // trick so that connections drawn within the scene can point to us
    // obtain instance from storyboard
    UINavigationController* nav = (UINavigationController*)[[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateInitialViewController];
        
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    // if I hadn't been able to use the firstResponder trick above,
    // I could have hooked up the buttons targets and actions like this:
//    UIViewController* root = [nav.viewControllers objectAtIndex: 0];
//    [root.navigationItem.leftBarButtonItem setTarget:self];
//    [root.navigationItem.leftBarButtonItem setAction:@selector(save:)];
//    [root.navigationItem.rightBarButtonItem setTarget:self];
//    [root.navigationItem.rightBarButtonItem setAction:@selector(cancel:)];

    
    // comment out next line and you'll see the bug when navigating back and forth between different sized content views
    // [iOS 5] bug still present in iOS 5
    nav.delegate = self; // I tried but failed to set this up in the storyboard
    self.currentPop = pop;
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

- (void) cancelPop1: (id) sender { // hooked up in storyboard by making us first responder
    // dismiss popover and revert choice
    [self.currentPop dismissPopoverAnimated:YES];
    self.currentPop = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:self->oldChoice forKey:@"choice"];
}

- (void) savePop1: (id) sender { // hooked up in storyboard by making us first responder
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
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:vc];
    pop.popoverContentSize = vc.view.frame.size;
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
