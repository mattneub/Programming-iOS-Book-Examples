

#import "FirstViewController.h"
#import "ExtraViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
- (IBAction)doPresent:(id)sender {
    UIViewController* vc = [ExtraViewController new];
    
    // uncomment these lines to see the difference (on iPad only)
    self.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // and then these (on iPad only)
    self.providesPresentationContextTransitionStyle = YES;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    // testing whether, using these styles, supported orientations is obeyed
//    vc.modalPresentationStyle = UIModalPresentationFormSheet; // no
//    vc.modalPresentationStyle = UIModalPresentationPageSheet; // no
    [self presentViewController:vc animated:YES completion:nil];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							

@end
