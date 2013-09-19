

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
    [self.panel addSubview: vc.view]; // insert view into interface between "will" and "did"
    // note: when we call add, we must call "did" afterwards
    [vc didMoveToParentViewController:self];
    
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.panel addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:@{@"v":vc.view}]];
    [self.panel addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:@{@"v":vc.view}]];

    
}

- (IBAction)doFlip:(id)sender {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIViewController* fromvc = self->_swappers[cur];
    cur = (cur == 0) ? 1 : 0;
    UIViewController* tovc = self->_swappers[cur];
    
    tovc.view.translatesAutoresizingMaskIntoConstraints = NO;
    // must have both as children before we can transition between them
    [self addChildViewController:tovc]; // "will" called for us
    // note: when we call remove, we must call "will" (with nil) beforehand
    [fromvc willMoveToParentViewController:nil];
    // then perform the transition
    [self transitionFromViewController:fromvc
                      toViewController:tovc
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                NSLog(@"%@", @"doing constraints");
                                [self.panel addConstraints:
                                 [NSLayoutConstraint
                                  constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:@{@"v":tovc.view}]];
                                [self.panel addConstraints:
                                 [NSLayoutConstraint
                                  constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:@{@"v":tovc.view}]];

                            }
                            completion:^(BOOL done){
                                // finally, finish up
                                // note: when we call add, we must call "did" afterwards
                                [tovc didMoveToParentViewController:self];
                                [fromvc removeFromParentViewController]; // "did" called for us
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                
                                NSLog(@"%@", self.panel.constraints);
                            }];
}

-(void)updateViewConstraints {
    NSLog(@"%@", @"update view constraints");
    [super updateViewConstraints];
}

@end
