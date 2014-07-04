

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"I %@ will be asked for the destination", self);
    UIViewController* vc = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
    NSLog(@"I %@ was asked for the destination, and I am returning %@", self, vc);
    return vc;
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    NSLog(@"I %@ will be asked for the segue", self);
    UIStoryboardSegue* seg = [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
    NSLog(@"I %@ was asked for the segue, and I am returning %@ %@", self, seg, seg.identifier);
    return seg;
}


-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"I %@ am being asked can perform from %@, and my background is %@", self, fromViewController, self.view.backgroundColor);
    return [super canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

-(IBAction) doUnwind: (UIStoryboardSegue*) seg {
    NSLog(@"I %@ was asked to unwind %@ %@", self, seg, seg.identifier);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"I %@ was asked to prepare for segue %@", self, segue);
}

-(BOOL)respondsToSelector:(SEL)aSelector {
    BOOL ok = [super respondsToSelector:aSelector];
    if (aSelector == @selector(doUnwind:))
    NSLog(@"I %@ was asked responds to selector %@, responding %d", self, NSStringFromSelector(aSelector), ok);
    return ok;
}


@end
