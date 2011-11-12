
#import "Popover1View1.h"

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

// curtailed, because we're using a static table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    int choice = [[NSUserDefaults standardUserDefaults] integerForKey:@"choice"];
    if (section == 0) {
        cell.accessoryType = (choice == row ? 
                              UITableViewCellAccessoryCheckmark : 
                              UITableViewCellAccessoryNone);
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
}

@end
