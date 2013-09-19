

#import "VC1.h"
#import "VC2.h"

@implementation VC1


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"VC1";
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(go:)];
    self.navigationItem.rightBarButtonItem = b;
}

- (void) go: (id) dummy {
    VC2* vc = [VC2 new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
