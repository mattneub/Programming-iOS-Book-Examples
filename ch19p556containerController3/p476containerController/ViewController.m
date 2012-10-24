

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView* panel;
@end

@implementation ViewController {
    int cur;
    NSMutableArray* _swappers;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->_swappers = [NSMutableArray array];
        [self->_swappers addObject: [[FirstViewController alloc] init]];
        [self->_swappers addObject: [[SecondViewController alloc] init]];
    }
    return self;
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
    // makes us responsible for the appear/disappear methods
}

-(BOOL)shouldAutomaticallyForwardRotationMethods {
    return NO;
    // makes us responsible for the three "rotate" events
    // however, there aren't any in this example
}


/*
 NB we are now responsible for forwarding will/did appear/disappear
 when we ourselves appear/disappear
 Thus we *must* implement all four of them
 */

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIViewController* child = self->_swappers[cur];
    if (child.isViewLoaded && child.view.superview)
        [child beginAppearanceTransition:YES animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIViewController* child = self->_swappers[cur];
    if (child.isViewLoaded && child.view.superview)
        [child endAppearanceTransition];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIViewController* child = self->_swappers[cur];
    if (child.isViewLoaded && child.view.superview)
        [child beginAppearanceTransition:NO animated:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UIViewController* child = self->_swappers[cur];
    if (child.isViewLoaded && child.view.superview)
        [child endAppearanceTransition];
}

/*
 on launch, we expect to see:
 <FirstViewController: 0x71c2140> willMove
 <FirstViewController: 0x71c2140> didMove
 <FirstViewController: 0x71c2140> willAppear
 <FirstViewController: 0x71c2140> didAppear
 
And that is exactly what we do see - because of our "appear" implementations just above 
 */



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // same as first example

    UIViewController* vc = self->_swappers[cur];
    [self addChildViewController:vc]; // "will" called for us
    
    vc.view.frame = self.panel.bounds;
    [self.panel addSubview: vc.view]; // insert view into interface between "will" and "did"
        
    // note: when we call add, we must call "did" afterwards
    [vc didMoveToParentViewController:self];
        
}

/*
 on first flip, we expect to see:
 
 <SecondViewController: 0x71c24d0> willMove
 <FirstViewController: 0x71c2140> willMove
 <FirstViewController: 0x71c2140> willDisappear
 <SecondViewController: 0x71c24d0> willAppear
 <SecondViewController: 0x71c24d0> didAppear
 <FirstViewController: 0x71c2140> didDisappear
 <SecondViewController: 0x71c24d0> didMove
 <FirstViewController: 0x71c2140> didMove
 
 and that is exactly what we do see

 */

- (IBAction)doFlip:(id)sender {
    
    // same as first example, but we do not forward automatically
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIViewController* fromvc = self->_swappers[cur];
    cur = (cur == 0) ? 1 : 0;
    UIViewController* tovc = self->_swappers[cur];
    tovc.view.frame = self.panel.bounds;
    
    // must have both as children before we can transition between them
    [self addChildViewController:tovc]; // "will" called for us
    // note: when we call remove, we must call "will" (with nil) beforehand
    [fromvc willMoveToParentViewController:nil];
    
    [fromvc beginAppearanceTransition:NO animated:YES]; // *
    [tovc beginAppearanceTransition:YES animated:YES]; // *
    
    // then perform the transition
    // we cannot call transitionFromViewController:toViewController:!
    // it tries to manage begin/end appearance itself ("legacy")
    // we just perform an ordinary transition
    
    [UIView transitionFromView:fromvc.view
                        toView:tovc.view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        [tovc endAppearanceTransition]; // *
                        [fromvc endAppearanceTransition]; // *
                        
                        // note: when we call add, we must call "did" afterwards
                        [tovc didMoveToParentViewController:self];
                        [fromvc removeFromParentViewController]; // "did" called for us
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    }];
    
    /*
    [self transitionFromViewController:fromvc
                      toViewController:tovc
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL done){
                                // finally, finish up
                                // note: when we call add, we must call "did" afterwards
                                [tovc didMoveToParentViewController:self];
                                [fromvc removeFromParentViewController]; // "did" called for us
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                            }];
     */
}



@end
