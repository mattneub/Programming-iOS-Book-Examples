
#import "RootViewController.h"

@implementation RootViewController

-(void)loadView {
    UIView* v = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    self.view = v;
    UITableView* tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,310) 
                                                   style:UITableViewStyleGrouped];
    [v addSubview:tv];
    tv.dataSource = self;
    tv.delegate = self;
    tv.scrollEnabled = NO;
    self.tableView = tv;
    [tv release];
    [v release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Size";
    return @"Style";
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 3;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tv 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier] autorelease];
    }
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if (section == 0) {
        if (row == 0) {
            cell.textLabel.text = @"Easy";
        } else if (row == 1) {
            cell.textLabel.text = @"Normal";
        } else if (row == 2) {
            cell.textLabel.text = @"Hard";
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.textLabel.text = @"Animals";
        } else if (row == 1) {
            cell.textLabel.text = @"Snacks";
        }
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([[ud valueForKey:@"Style"] isEqualToString:cell.textLabel.text] ||
        [[ud valueForKey:@"Size"] isEqualToString:cell.textLabel.text])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

- (void)tableView:(UITableView *)tv 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* setting = [tv cellForRowAtIndexPath:indexPath].textLabel.text;
    [ud setValue:setting forKey:
     [self tableView:tv titleForHeaderInSection:indexPath.section]];
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
