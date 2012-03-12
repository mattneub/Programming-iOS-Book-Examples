

#import "RootViewController.h"
#import "WebViewController.h"

@implementation RootViewController


- (IBAction)doButton:(id)sender {
    WebViewController* wvc = [[WebViewController alloc] init];
    [self.navigationController pushViewController:wvc animated:YES];
    [wvc release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Start";
}


@end
