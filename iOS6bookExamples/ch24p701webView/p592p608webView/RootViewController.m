

#import "RootViewController.h"
#import "WebViewController.h"

@implementation RootViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = @"root";
    }
    return self;
}

- (IBAction)doButton:(id)sender {
    WebViewController* wvc = [WebViewController new];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Start";
}


@end
