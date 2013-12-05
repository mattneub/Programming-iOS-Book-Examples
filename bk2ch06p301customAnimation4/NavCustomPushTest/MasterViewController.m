

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()
@end

@implementation MasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(doPush:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void) doPush: (id) sender {
//    NSLog(@"%@", [self.view.window performSelector:@selector(recursiveDescription)]);
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // NSLog(@"%@", self.navigationController.interactivePopGestureRecognizer);
    
//    NSLog(@"%@", [self.view.window performSelector:@selector(recursiveDescription)]);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        [[segue destinationViewController] setDetailItem:[NSDate date]];
    }
}

@end
