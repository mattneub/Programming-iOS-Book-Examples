

#import "RootViewController.h"
#import "Popover1View1.h"

@implementation RootViewController
@synthesize currentPop;

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(backgrounding:) 
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [currentPop release];
    [super dealloc];
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
    [b release]; 
    b = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem: UIBarButtonSystemItemDone
         target: self
         action: @selector(savePop1:)]; 
    vc.navigationItem.leftBarButtonItem = b;
    [b release];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:nav];
    // comment out next line and you'll see the bug when navigating back and forth between different sized content views
    nav.delegate = self;
    [nav release];
    [vc release];
    self.currentPop = pop;
    [pop presentPopoverFromBarButtonItem:sender 
                permittedArrowDirections:UIPopoverArrowDirectionAny 
                                animated:YES];
    // comment out next line and you'll see that Bad Things can happen
    // can summmon same popover twice
    // also note that this line must come *after* we present the popover or it is ineffectual
    pop.passthroughViews = nil;
    // this is a popover where the user can make changes but then cancel them
    // thus we need to preserve the current values in case we have to revert (cancel) later
    self->oldChoice = [[NSUserDefaults standardUserDefaults] integerForKey:@"choice"];
    // make ourselves delegate so we learn when popover is dismissed
    pop.delegate = self;
    [pop release];
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
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:vc];
    pop.popoverContentSize = vc.view.frame.size;
    self.currentPop = pop;
    [pop presentPopoverFromBarButtonItem:sender 
                permittedArrowDirections:UIPopoverArrowDirectionAny 
                                animated:YES];
    pop.passthroughViews = nil;
    pop.delegate = self;
    [vc release];
    [pop release];
}


// I'd rather not have popovers showing thru rotation
// this dismissal counts as a cancel
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIPopoverController* pc = self.currentPop;
    if (pc) {
        if ([pc.contentViewController isKindOfClass: [UINavigationController class]])
            [[NSUserDefaults standardUserDefaults] setInteger:self->oldChoice forKey:@"choice"];
        [pc dismissPopoverAnimated:NO];
        pc = nil;
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
        pc = nil;
    }
}

// was that messy or what?????
// but I don't see a better way, in the absence of decent built-in popover management
// and of course if this app had more popovers it could get even messier!

@end
