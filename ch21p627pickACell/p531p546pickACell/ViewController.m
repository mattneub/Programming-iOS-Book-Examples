

#import "ViewController.h"

@implementation ViewController

//@synthesize tableView;

// look, ma, no three big questions!
// sections, section headers, titles for each row, all set up in storyboard
// ("static tables")

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

// new iOS 6 feature
// if we implement this *and* return NO, the cell becomes unselectable
// hard to believe, but previously there was no way to designate individual cell nonselectable

-(BOOL)tableView:(UITableView *)tv shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES; // try NO to test this feature
}

// new iOS 6 feature
// can learn about highlight in addition to select

-(void)tableView:(UITableView *)tv didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"unhighlight %@", [tv cellForRowAtIndexPath:indexPath].textLabel.text);
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* setting = [tv cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString* header = [self tableView:tv titleForHeaderInSection:indexPath.section];
    [ud setValue:setting forKey:header];
    //[tv reloadData]; // deselect all cells, reassign checkmark as needed
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select");
//    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
//    NSString* setting = [tv cellForRowAtIndexPath:indexPath].textLabel.text;
//    NSString* header = [self tableView:tv titleForHeaderInSection:indexPath.section];
//    [ud setValue:setting forKey:header];
    
    // note that we must do this reload here
    // otherwise selection will follow our reload, and will stay (and checkmarks will be off)
    [tv reloadData]; // deselect all cells, reassign checkmark as needed
}


@end
