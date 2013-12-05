

#import "ViewController.h"
#import "ChildViewController1.h"
#import "ChildViewController2.h"

@interface ViewController ()

@end

@implementation ViewController {
    int _cur;
    NSMutableArray* _swappers;
}

#define which 2 // 1 means automatic, 2 means manual, try both

#if which == 2

-(BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
    // makes us responsible for the appear/disappear methods
    // they won't be sent to our child automatically, even on launch!
}

-(BOOL)shouldAutomaticallyForwardRotationMethods {
    return NO;
    // makes us responsible for the three "rotate" events
    // however, there aren't any in this example
}

#endif

-(void)viewDidLoad {
    self->_swappers = [NSMutableArray new];
    [self->_swappers addObject:self.childViewControllers[0]];
    [self->_swappers addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"child2"]];
}

/*
 On startup we expect to see:
 
 <ChildViewController1: 0x8994fc0> willMove to <ViewController: 0x898d6f0>
 <ChildViewController1: 0x8994fc0> didMove to <ViewController: 0x898d6f0>
 <ChildViewController1: 0x8994fc0> willAppear
 <ChildViewController1: 0x8994fc0> update constraints
 <ChildViewController1: 0x8994fc0> will layout
 <ChildViewController1: 0x8994fc0> did layout
 <ChildViewController1: 0x8994fc0> didAppear
 
 */

/*
 NB we are now responsible for forwarding will/did appear/disappear
 when we ourselves appear/disappear
 Thus we *must* implement all four of them
 */

#if which == 2

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"%@", @"FORWARDING MANUALLY");
    [super viewWillAppear:animated];
    UIViewController* child = self->_swappers[self->_cur];
    if (child.isViewLoaded && child.view.superview)
        [child beginAppearanceTransition:YES animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIViewController* child = self->_swappers[self->_cur];
    if (child.isViewLoaded && child.view.superview)
        [child endAppearanceTransition];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIViewController* child = self->_swappers[self->_cur];
    if (child.isViewLoaded && child.view.superview)
        [child beginAppearanceTransition:NO animated:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UIViewController* child = self->_swappers[self->_cur];
    if (child.isViewLoaded && child.view.superview)
        [child endAppearanceTransition];
}

#endif


/*
 
 On flip we expect to see (one way round or the other):

<ChildViewController2: 0x8997a10> willMove to <ViewController: 0x898d6f0>
<ChildViewController1: 0x8994fc0> willMove to (null)
<ChildViewController1: 0x8994fc0> willDisappear
<ChildViewController2: 0x8997a10> willAppear
<ChildViewController2: 0x8997a10> update constraints
<ChildViewController2: 0x8997a10> will layout
<ChildViewController2: 0x8997a10> did layout
<ChildViewController2: 0x8997a10> didAppear
<ChildViewController1: 0x8994fc0> didDisappear
<ChildViewController2: 0x8997a10> didMove to <ViewController: 0x898d6f0>
<ChildViewController1: 0x8994fc0> didMove to (null)
 
 */

- (IBAction)doFlip:(id)sender {
    UIViewController* fromvc = self->_swappers[self->_cur];
    self->_cur = (self->_cur == 0) ? 1 : 0;
    UIViewController* tovc = self->_swappers[self->_cur];
    
    tovc.view.frame = fromvc.view.superview.bounds;
    
    // must have both as children before we can transition between them
    [self addChildViewController:tovc]; // "will" called for us
    // note: when we call remove, we must call "will" (with nil) beforehand
    [fromvc willMoveToParentViewController:nil];
    
#if which == 1

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
                            }];
    
#elif which == 2
    
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
                    }];
#endif

}


@end
