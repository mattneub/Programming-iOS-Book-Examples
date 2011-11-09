

#import "ViewController.h"

@implementation ViewController

@synthesize tableView;

// look, ma, no three big questions!
// sections, section headers, titles for each row, all set up in storyboard
// ("static tables")

// in case you don't think storyboards can be cool, look at how much code
// we eliminated in iOS 5 vs iOS 4 version of this same example

- (UITableViewCell *)tableView:(UITableView *)tv 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // we can still modify the cell as long as we fetch it from super
    UITableViewCell* cell = [super tableView:tv cellForRowAtIndexPath:indexPath];
    
    // supply checkmarks as necessary
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];

    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([[ud valueForKey:@"Style"] isEqualToString:cell.textLabel.text] ||
        [[ud valueForKey:@"Size"] isEqualToString:cell.textLabel.text])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* setting = [tv cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString* header = [self tableView:tv titleForHeaderInSection:indexPath.section];
    [ud setValue:setting forKey:header];
    [tv reloadData]; // deselect all cells, reassign checkmark as needed
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
