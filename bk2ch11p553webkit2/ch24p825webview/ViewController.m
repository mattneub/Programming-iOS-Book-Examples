

#import "ViewController.h"
#import "ch24p825webkit2-Swift.h"

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)doButton:(id)sender {
    WebViewController* wvc = [[WebViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Start";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


@end
