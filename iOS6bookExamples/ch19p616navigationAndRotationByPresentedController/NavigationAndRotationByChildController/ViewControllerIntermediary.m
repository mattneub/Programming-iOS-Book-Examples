

#import "ViewControllerIntermediary.h"

@interface ViewControllerIntermediary () <UINavigationControllerDelegate>
@end

// this isn't in the book, but it's a kind of solution to a problem people encounter a lot in iOS 6
// how to force rotation when pushing/popping in a navigation interface
// you can't do it, so you use a presented view controller instead, to make it *look* like you're doing it

@implementation ViewControllerIntermediary {
    BOOL _comingBack;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

-(void)navigationController:(UINavigationController *)nc willShowViewController:(UIViewController *)vc animated:(BOOL)anim {
    if (self == vc)
        [nc setNavigationBarHidden:YES animated:_comingBack];
    else
        [nc setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_comingBack) {
        [self performSegueWithIdentifier:@"pushme" sender:self];
        _comingBack = YES;
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
