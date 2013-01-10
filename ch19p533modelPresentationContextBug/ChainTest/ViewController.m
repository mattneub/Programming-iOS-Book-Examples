

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)doButton:(id)sender {
    self.definesPresentationContext = YES;
    UIViewController* vc = [SecondViewController new];
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}


@end
