
#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, weak) IBOutlet UINavigationBar *nav;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:@"Tinker"];
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Evers"
                                                          style:UIBarButtonItemStyleBordered 
                                                         target:self action:@selector(pushNext:)];
    ni.rightBarButtonItem = b;
    self.nav.items = @[ni]; // self.nav is the UINavigationBar
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
    }
    [self.nav pushNavigationItem:ni animated:YES];
}

/*
 Also, in the running app, notice the subtle shadow at the bottom in iOS 6
 This is present provided we do not clip to bounds
 You can provide your own shadowImage if you are customizing the background image
 */

/*
 Another new role of the nav bar in iOS 6 is that its color affects the status bar color on iPhone
 */


@end
