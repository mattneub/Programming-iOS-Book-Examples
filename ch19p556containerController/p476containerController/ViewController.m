

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIViewController* vc = self->_swappers[cur];
    [self addChildViewController:vc]; // "will" called for us
    vc.view.frame = self.panel.bounds;
    [self.panel addSubview: vc.view]; // insert view into interface between "will" and "did"
    // note: when we call add, we must call "did" afterwards
    [vc didMoveToParentViewController:self];
        
}

- (IBAction)doFlip:(id)sender {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIViewController* fromvc = self->_swappers[cur];
    cur = (cur == 0) ? 1 : 0;
    UIViewController* tovc = self->_swappers[cur];
    tovc.view.frame = self.panel.bounds;
    
    // must have both as children before we can transition between them
    [self addChildViewController:tovc]; // "will" called for us
    // note: when we call remove, we must call "will" (with nil) beforehand
    [fromvc willMoveToParentViewController:nil];
    // then perform the transition
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
}

@end
