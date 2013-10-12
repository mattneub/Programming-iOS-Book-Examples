

#import "ViewController.h"
#import "Popover1View1.h"
#import "MyPopoverBackgroundView.h"
#import "ExtraViewController.h"

@interface ViewController () <UIToolbarDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, weak) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) UIPopoverController* currentPop;
@property (nonatomic, weak) IBOutlet UIButton* button;
@property (nonatomic, weak) IBOutlet UIButton* button2;
@end

@implementation ViewController {
    NSInteger _oldChoice;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.toolbar.delegate = self;
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
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


-(IBAction)doPopover1:(id)sender {
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
    
    UIButton* bb = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [bb addTarget:self action:@selector(doPresent:) forControlEvents:UIControlEventTouchUpInside];
    [bb sizeToFit];
    vc.navigationItem.titleView = bb;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:nav];
    // comment out next line and you'll see the bug when navigating back and forth between different sized content views
    nav.delegate = self;
    self.currentPop = pop;
    // pop.passthroughViews = nil; // ineffectual at this point

    // pop.popoverLayoutMargins = UIEdgeInsetsMake(200,200,200,200);
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
    //pop.passthroughViews = @[self.button];
    // this is a popover where the user can make changes but then cancel them
    // thus we need to preserve the current values in case we have to revert (cancel) later
    self->_oldChoice = [[NSUserDefaults standardUserDefaults] integerForKey:@"choice"];
    // make ourselves delegate so we learn when popover is dismissed
    pop.delegate = self;
    
    // new iOS 7 feature; try it with and without
    pop.backgroundColor = [UIColor yellowColor];
    nav.navigationBar.barTintColor = [UIColor redColor]; // no effect
    nav.navigationBar.backgroundColor = [UIColor redColor];
    nav.navigationBar.tintColor = [UIColor whiteColor];

}

// deal with content size change bug

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    navigationController.preferredContentSize = viewController.preferredContentSize;
}

// state saving on dismissal

- (void) cancelPop1: (id) sender {
    // dismiss popover and revert choice
    [self.currentPop dismissPopoverAnimated:YES];
    self.currentPop = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:self->_oldChoice forKey:@"choice"];
}

- (void) savePop1: (id) sender {
    // dismiss popover and don't revert choice
    [self.currentPop dismissPopoverAnimated:YES];
    self.currentPop = nil;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)pc {
    if ([pc.contentViewController isKindOfClass: [UINavigationController class]])
        [[NSUserDefaults standardUserDefaults] setInteger:self->_oldChoice forKey:@"choice"];
    self.currentPop = nil;
}


- (void) doPresent: (id) sender {
    // return; // demonstrates odd constraints bug in presented-in-popover views
    // hmmm, whatever the bug was, I guess it is now fixed; I don't see a problem
    [self.currentPop.contentViewController presentViewController:[ExtraViewController new] animated:YES completion:nil];
}

// testing new iOS 7 feature

- (IBAction)doButton:(id)sender {
    UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:[UIViewController new]];
    self.currentPop = pop;
    pop.delegate = self;
    [pop presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    // just playing!
    if (*view == self.button) {
        *rect = self.button2.bounds;
        *view = self.button2;
    }
}

- (IBAction) doPopover2: (id) sender {
    UIViewController* vc = [[UIViewController alloc] init];
    vc.view.frame = CGRectMake(0,0,300,300);
    vc.view.backgroundColor = [UIColor greenColor];
    vc.preferredContentSize = CGSizeMake(300,300);
    // vc.modalInPopover = YES;
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
    // we can force the popover further from the edge of the screen
    // silly example: just a little extra space at this popover's right
    pop.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 40);
    // we can supply the background view
    pop.popoverBackgroundViewClass = [MyPopoverBackgroundView class];
    self.currentPop = pop;
    [pop presentPopoverFromBarButtonItem:sender
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];
    pop.passthroughViews = nil;
    pop.delegate = self;
    
}

- (void) tapped: (UIGestureRecognizer*) g {
    UIViewController* vc = [[UIViewController alloc] init];
    vc.view.frame = CGRectMake(0,0,300,300);
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.preferredContentSize = vc.view.frame.size;
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
    // uncomment next line if you'd like to crash; only coverVertical is legal
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UIViewController* presenter = (UIViewController*)[g.view nextResponder];
    [presenter presentViewController:vc animated:YES completion:^{
        NSLog(@"%@", @"presented");
    }];
    // uncomment next line and we'll be non-modal, but you shouldn't
    // vc.modalInPopover = NO;
    //self.currentPop.passthroughViews = nil;
}

- (void) done: (UIButton*) sender {
    UIResponder* r = sender;
    while (![r isKindOfClass: [UIViewController class]])
        r = [r nextResponder];
    [(UIViewController*)r dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", @"dismissed");
    }];
}

// optional: can dismiss on rotation / backgrounding (uncomment "return" statements)

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    return;
    UIPopoverController* pc = self.currentPop;
    if (pc) {
        if ([pc.contentViewController isKindOfClass: [UINavigationController class]])
            [[NSUserDefaults standardUserDefaults] setInteger:self->_oldChoice forKey:@"choice"];
        [pc dismissPopoverAnimated:NO];
        self.currentPop = nil;
    }
}

-(void)backgrounding:(id)dummy { // notification
    return;
    UIPopoverController* pc = self.currentPop;
    if (pc) {
        if ([pc.contentViewController isKindOfClass: [UINavigationController class]])
            [[NSUserDefaults standardUserDefaults] setInteger:self->_oldChoice forKey:@"choice"];
        [pc dismissPopoverAnimated:NO];
        self.currentPop = nil;
    }
}

@end
