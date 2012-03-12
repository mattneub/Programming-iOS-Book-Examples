

#import "RootViewController.h"
#import "MyCell.h"

@implementation RootViewController
@synthesize name, numbers, aCell;


#pragma mark -
#pragma mark View lifecycle

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.name = @"Matt Neuburg";
    self.numbers = [NSMutableArray arrayWithObject:@"(123) 456-7890"];
    self.tableView.allowsSelection = NO;
    
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    return [self.numbers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:self options:nil];
        cell = self.aCell;
    }
    
	// Configure the cell.
    if (indexPath.section == 0)
        ((MyCell*)cell).textField.text = self.name;
    if (indexPath.section == 1) {
        ((MyCell*)cell).textField.text = [self.numbers objectAtIndex: indexPath.row];
        ((MyCell*)cell).textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    ((MyCell*)cell).textField.delegate = self;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Name";
    return @"Number";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSInteger ct = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (ct-1 == indexPath.row)
            return UITableViewCellEditingStyleInsert;
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
        return YES;
    return NO;
}

- (void) tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.numbers addObject: @""];
        NSInteger ct = [self.numbers count];
        [tableView insertRowsAtIndexPaths:
         [NSArray arrayWithObject: [NSIndexPath indexPathForRow: ct-1 inSection:1]]
                         withRowAnimation:UITableViewRowAnimationMiddle];
        [self performSelector:@selector(selectLast) withObject:nil afterDelay:0.4];
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.numbers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void) selectLast {
    NSInteger ct = [self.numbers count];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:ct-2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:
                             [NSIndexPath indexPathForRow:ct-1 inSection:1]];
    [((MyCell*)cell).textField becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    [tf endEditing:YES];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)tf {
    // some cell's text field has finished editing; which cell?
    UIView* v = tf;
    do {
        v = v.superview;
    } while (![v isKindOfClass: [UITableViewCell class]]);
    MyCell* cell = (MyCell*)v;
    // update data model to match
    NSIndexPath* ip = [self.tableView indexPathForCell:cell];
    if (ip.section == 1)
        [self.numbers replaceObjectAtIndex:ip.row withObject:cell.textField.text];
    else if (ip.section == 0)
        self.name = cell.textField.text;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString* s = [self.numbers objectAtIndex: fromIndexPath.row];
    [s retain];
    [self.numbers removeObjectAtIndex: fromIndexPath.row];
    [self.numbers insertObject:s atIndex: toIndexPath.row];
    [s release];
    [tableView reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    [tableView endEditing:YES];
    if (proposedDestinationIndexPath.section == 0)
        return [NSIndexPath indexPathForRow:0 inSection:1];
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && [self.numbers count] > 1)
        return YES;
    return NO;
}

- (void)dealloc {
    [name release];
    [numbers release];
    [super dealloc];
}

@end

