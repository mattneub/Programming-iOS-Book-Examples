

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray* states;
@property (nonatomic, strong) NSArray* filteredStates;
@end

@implementation RootViewController
@synthesize states, filteredStates;

// same as in iOS 4 but I moved this code to init
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString* s = [NSString stringWithContentsOfFile:
                       [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] 
                                                encoding:NSUTF8StringEncoding error:nil];
        self->states = [s componentsSeparatedByString:@"\n"];
    }
    return self;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
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

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    // NSLog(@"%@", controller);
    // you could get a reference to the controller's _popoverController at this point...
    // but such an app presumably wouldn't get past the App Store review process
}

@end
