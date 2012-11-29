

#import "MasterViewController.h"


@interface MasterViewController () <UITextFieldDelegate>
@end

@implementation MasterViewController



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *s = [NSString stringWithFormat:@"%i", indexPath.row];
    [(UITextField*)[cell.contentView subviews][0] setPlaceholder:s];
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // logging reveals how this trick is performed:
    // the UITableViewController has changed the contentInset and scrollIndicatorInsets
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.tableView.scrollIndicatorInsets));
    
    [textField endEditing:YES];
    return NO;
}


@end
