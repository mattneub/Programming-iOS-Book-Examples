

#import "RootViewController.h"

@implementation RootViewController
@synthesize states, filteredStates;

- (void) awakeFromNib {
    [super awakeFromNib];
    NSString* s = [NSString stringWithContentsOfFile:
                   [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] 
                                            encoding:NSUTF8StringEncoding error:nil];
    self.states = [s componentsSeparatedByString:@"\n"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [self.filteredStates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    cell.textLabel.text = [self.filteredStates objectAtIndex: indexPath.row];
    return cell;
}

- (void) filterData {
    NSString* target = self.searchDisplayController.searchBar.text;
    NSPredicate* p = [NSPredicate predicateWithBlock:
                      ^(id obj, NSDictionary *d) {
                          NSString* s = obj;
                          NSStringCompareOptions options = NSCaseInsensitiveSearch;
                          BOOL b = [s rangeOfString:target options:options].location != NSNotFound;
                          return b;
                      }];
    self.filteredStates = [states filteredArrayUsingPredicate:p];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterData];
}

@end
