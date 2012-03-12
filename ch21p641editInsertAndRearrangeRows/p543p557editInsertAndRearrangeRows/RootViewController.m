

#import "RootViewController.h"
#import "MyCell.h"

@interface RootViewController ()
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSMutableArray* numbers;
@end

@implementation RootViewController
@synthesize name, numbers;

#pragma mark -
#pragma mark View lifecycle

static NSString *CellIdentifier = @"Cell";

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.name = @"Matt Neuburg";
    self.numbers = [NSMutableArray arrayWithObject:@"(123) 456-7890"];
    self.tableView.allowsSelection = NO;
    // new iOS 5 way
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
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
    
    // cell is auto-loaded as needed thanks to previous registerNib call
    MyCell* cell = (MyCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	// Configure the cell.
    if (indexPath.section == 0)
        cell.textField.text = self.name;
    if (indexPath.section == 1) {
        cell.textField.text = [self.numbers objectAtIndex: indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    cell.textField.delegate = self;
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
    [tableView endEditing:YES]; // added, because user can click minus/plus while still editing
                                // so we must force saving to the model
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.numbers addObject: @""];
        NSInteger ct = [self.numbers count];
        [tableView beginUpdates];
        // animation automatic new in iOS 5
        [tableView insertRowsAtIndexPaths:
         [NSArray arrayWithObject: [NSIndexPath indexPathForRow: ct-1 inSection:1]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        // at the time I wrote the book, this next bit of code had to be delayed
        // but now the problem is fixed, and we can just go ahead
        [self.tableView reloadRowsAtIndexPaths:
         [NSArray arrayWithObject:[NSIndexPath indexPathForRow:ct-2 inSection:1]] 
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        // crucial that this next bit be *outside* the update block
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:
                                 [NSIndexPath indexPathForRow:ct-1 inSection:1]];
        [((MyCell*)cell).textField becomeFirstResponder];
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.numbers removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates]; // added; use of update block makes animations work together
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationAutomatic]; // new in iOS 5
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic]; // added, to deal with rearrange handle
        [tableView endUpdates];
    }
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
    [self.numbers removeObjectAtIndex: fromIndexPath.row];
    [self.numbers insertObject:s atIndex: toIndexPath.row];
    [tableView reloadData]; // to get plus and minus buttons to redraw themselves
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


@end

