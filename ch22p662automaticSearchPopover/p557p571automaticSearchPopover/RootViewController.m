

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray* states;
@property (nonatomic, strong) NSArray* filteredStates;
@end

@implementation RootViewController

// same as in iOS 4 but I moved this code to init
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString* s = [NSString stringWithContentsOfFile:
                       [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] 
                                                encoding:NSUTF8StringEncoding error:nil];
        self->_states = [s componentsSeparatedByString:@"\n"];
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // tricky to find a reliable place to do this
    // must precede all uses of cellForRow
    // but can't do early in view controller code...
    // because search display controller keeps destroying and recreating the table view
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [self.filteredStates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
    self.filteredStates = [self.states filteredArrayUsingPredicate:p];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterData];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    // NSLog(@"%@", controller);
    // you could get a reference to the controller's _popoverController at this point...
    // but such an app presumably wouldn't get past the App Store review process
}

- (IBAction)doTestButton:(id)sender {
    NSLog(@"test button"); // this should not happen when the popover is showing
    // and it doesn't
    // so the right thing is happening all by itself
}

@end
