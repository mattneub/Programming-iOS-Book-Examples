
#import "RootViewController.h"

@implementation RootViewController
@synthesize nav;

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:@"Tinker"];
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Evers"
                                                          style:UIBarButtonItemStyleBordered 
                                                         target:self action:@selector(pushNext:)];
    ni.rightBarButtonItem = b;
    [b release];
    nav.items = [NSArray arrayWithObject: ni]; // nav is the UINavigationBar
    [ni release];
}

- (void) pushNext: (id) sender {
    UIBarButtonItem* oldb = sender;
    NSString* s = oldb.title;
    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:s];
    if ([s isEqualToString: @"Evers"]) {
        UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Chance"
                                                              style:UIBarButtonItemStyleBordered 
                                                             target:self action:@selector(pushNext:)];
        ni.rightBarButtonItem = b;
        [b release];
    }
    [nav pushNavigationItem:ni animated:YES];
    [ni release];
}

- (void)dealloc {
    [nav release];
    [super dealloc];
}

@end
