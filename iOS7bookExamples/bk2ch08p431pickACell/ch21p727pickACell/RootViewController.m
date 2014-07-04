

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // we can still modify the cell as long as we fetch it from super
    UITableViewCell* cell = [super tableView:tv cellForRowAtIndexPath:indexPath];
    
    // supply checkmarks as necessary
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"about to update %@", cell.textLabel.text);
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([[ud valueForKey:@"Style"] isEqualToString:cell.textLabel.text] ||
        [[ud valueForKey:@"Size"] isEqualToString:cell.textLabel.text])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

-(BOOL)tableView:(UITableView *)tv shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"should highlight %@", [tv cellForRowAtIndexPath:indexPath].textLabel.text);
    NSLog(@"cell highlighted? %d", [tv cellForRowAtIndexPath:indexPath].highlighted);
    NSLog(@"label highlighted? %d", [tv cellForRowAtIndexPath:indexPath].textLabel.highlighted);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", @"callback from should highlight");
    });
    
    return YES; // try NO to test this feature
}

- (void)tableView:(UITableView *)tv didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did highlight %@", [tv cellForRowAtIndexPath:indexPath].textLabel.text);
    NSLog(@"cell highlighted? %d", [tv cellForRowAtIndexPath:indexPath].highlighted);
    NSLog(@"label highlighted? %d", [tv cellForRowAtIndexPath:indexPath].textLabel.highlighted);
    
}


-(void)tableView:(UITableView *)tv didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did unhighlight %@", [tv cellForRowAtIndexPath:indexPath].textLabel.text);
    NSLog(@"cell highlighted? %d", [tv cellForRowAtIndexPath:indexPath].highlighted);
    NSLog(@"label highlighted? %d", [tv cellForRowAtIndexPath:indexPath].textLabel.highlighted);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", @"callback from did unhighlight");
    });
    
}

- (NSIndexPath*)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will select %@", [tv cellForRowAtIndexPath:indexPath].textLabel.text);
    NSLog(@"cell highlighted? %d", [tv cellForRowAtIndexPath:indexPath].highlighted);
    NSLog(@"label highlighted? %d", [tv cellForRowAtIndexPath:indexPath].textLabel.highlighted);
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tv willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will deselect %@", [tv cellForRowAtIndexPath:indexPath].textLabel.text);
    NSLog(@"cell highlighted? %d", [tv cellForRowAtIndexPath:indexPath].highlighted);
    NSLog(@"label highlighted? %d", [tv cellForRowAtIndexPath:indexPath].textLabel.highlighted);
    
    return indexPath;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select %@", [tv cellForRowAtIndexPath:indexPath].textLabel.text);
    NSLog(@"cell highlighted? %d", [tv cellForRowAtIndexPath:indexPath].highlighted);
    NSLog(@"label highlighted? %d", [tv cellForRowAtIndexPath:indexPath].textLabel.highlighted);
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* setting = [tv cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString* header = [self tableView:tv titleForHeaderInSection:indexPath.section];
    [ud setValue:setting forKey:header];
    
    NSLog(@"%@", @"about to reload!");
    [tv reloadData]; // deselect all cells, reassign checkmark as needed
}

- (void)tableView:(UITableView *)tv didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did deselect %@", [tv cellForRowAtIndexPath:indexPath].textLabel.text);
    
}

/*

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView* v = (UITableViewHeaderFooterView*) view;
    v.detailTextLabel.text = @"Testing";
}
 
 */


@end
