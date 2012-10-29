
#import "Popover1View1.h"


@implementation Popover1View1



#pragma mark - View lifecycle


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView 
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
}

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
