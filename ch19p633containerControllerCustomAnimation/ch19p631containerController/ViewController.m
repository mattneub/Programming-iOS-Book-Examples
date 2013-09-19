

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
    UIGraphicsBeginImageContextWithOptions(tovc.view.bounds.size, YES, 0);
    [tovc.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
    iv.frame = CGRectZero;
    [self.panel addSubview:iv];
    tovc.view.alpha = 0;
    
    
    [self addChildViewController:tovc];
    [fromvc willMoveToParentViewController:nil];
    [self transitionFromViewController:fromvc
                      toViewController:tovc
                              duration:0.4
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                iv.frame = self.panel.bounds;
                            }
                            completion:^(BOOL done){
                                tovc.view.alpha = 1;
                                [iv removeFromSuperview];
                                [tovc didMoveToParentViewController:self];
                                [fromvc removeFromParentViewController]; // "did" called for us
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                [self constrainInPanel:tovc.view];
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
