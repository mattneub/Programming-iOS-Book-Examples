
#import "Popover1View1.h"
#import "Popover1View2.h"


@implementation Popover1View1



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // as far as I can tell, this has to be determined experimentally
    self.contentSizeForViewInPopover = CGSizeMake(320,180);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if (section == 0)
        result = 2;
    if (section == 1)
        result = 1;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    int choice = [[NSUserDefaults standardUserDefaults] integerForKey:@"choice"];
    if (section == 0) {
        if (row == 0)
            cell.textLabel.text = @"First";
        if (row == 1)
            cell.textLabel.text = @"Second";
        cell.accessoryType = (choice == row ? 
                              UITableViewCellAccessoryCheckmark : 
                              UITableViewCellAccessoryNone);
    }
    if (section == 1) {
        cell.textLabel.text = @"Change size";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"choice"];
        [tableView reloadData];
    }
    if (section == 1) {
        Popover1View2* nextView = [[Popover1View2 alloc] init];
        [self.navigationController pushViewController:nextView animated:YES];
    }
}

@end
