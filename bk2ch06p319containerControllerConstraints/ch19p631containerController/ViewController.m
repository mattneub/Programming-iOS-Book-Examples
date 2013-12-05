

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"


@interface ViewController () 
@property (weak, nonatomic) IBOutlet UIView *panel;

@end

@implementation ViewController {
    int _cur;
    NSMutableArray* _swappers;
}

-(void)awakeFromNib {
    self->_swappers = [NSMutableArray new];
    [self->_swappers addObject: [FirstViewController new]];
    [self->_swappers addObject: [SecondViewController new]];
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIViewController* vc = self->_swappers[_cur];
    [self addChildViewController:vc]; // "will" called for us
    [self.panel addSubview: vc.view]; // insert view into interface between "will" and "did"
    // note: when we call add, we must call "did" afterwards
    [vc didMoveToParentViewController:self];
    
    [self constrainInPanel:vc.view]; // *

}

- (IBAction)doFlip:(id)sender {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIViewController* fromvc = self->_swappers[_cur];
    _cur = (_cur == 0) ? 1 : 0;
    UIViewController* tovc = self->_swappers[_cur];
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
                            animations:^{
                                [self constrainInPanel: tovc.view]; // *
                            }
                            completion:^(BOOL done){
                                // finally, finish up
                                // note: when we call add, we must call "did" afterwards
                                [tovc didMoveToParentViewController:self];
                                [fromvc removeFromParentViewController]; // "did" called for us
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                            }];

}

- (void) constrainInPanel: (UIView*) v {
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [self.panel addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:@{@"v":v}]];
    [self.panel addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:@{@"v":v}]];
}

@end
