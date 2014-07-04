

#import "Popover1View1.h"
#import "Popover1View2.h"

@interface Popover1View1 ()

@end

@implementation Popover1View1

- (void)viewDidLoad
{
    [super viewDidLoad];
    // as far as I can tell, this has to be determined experimentally
    self.preferredContentSize = CGSizeMake(320,220);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger choice = [[NSUserDefaults standardUserDefaults] integerForKey:@"choice"];
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
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
