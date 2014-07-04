

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embed"]) {
        NSLog(@"%@ %@ %@", segue.identifier, segue.sourceViewController, segue.destinationViewController);
        NSLog(@"%d", [segue.destinationViewController isViewLoaded]);
        NSLog(@"%@", [segue.sourceViewController childViewControllers]);
        NSLog(@"%@", [self childViewControllers]);
    }

}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"did load %@ %@", self.view, [self childViewControllers]);
    // NSLog(@"%d", [self.childViewControllers[0] isViewLoaded]);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"did appear %@ %@", self.view, [self childViewControllers]);
}

@end
