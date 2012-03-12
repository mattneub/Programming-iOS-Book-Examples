

#import "RootViewController.h"

@interface RootViewController () 
@property (nonatomic, strong) UISearchDisplayController* sbc;
@property (nonatomic, strong) NSArray* states;
@property (nonatomic, strong) NSArray* filteredStates;
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@end

@implementation RootViewController
@synthesize sbc, states, filteredStates, sectionNames, sectionData;

-(void) createData { // not in nib any more so can't use awakeFromNib for this
    
    NSString* s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    self.states = [s componentsSeparatedByString:@"\n"];
    
    // compare p 523, sections
    self.sectionNames = [NSMutableArray array];
    self.sectionData = [NSMutableArray array];
    NSString* previous = @"";
    for (NSString* aState in self.states) {
        // get the first letter
        NSString* c = [aState substringToIndex:1];
        // only add a letter to sectionNames when it's a different letter
        if (![c isEqualToString: previous]) {
            previous = c;
            [sectionNames addObject: [c uppercaseString]];
            // and in that case, also add a new array to our array of arrays
            NSMutableArray* oneSection = [NSMutableArray array];
            [sectionData addObject: oneSection];
        }
        [[sectionData lastObject] addObject: aState];
    }
}

#define which 1 // try also "2" for scope buttons, "3" for sections, "4" for sections with magnifying glass

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createData];
    self.navigationItem.title = @"States";
    UISearchBar* b = [[UISearchBar alloc] init];
    [b sizeToFit];
    switch (which) {
        case 1: break;
        case 2:
        case 3:
        case 4:
        {
            b.scopeButtonTitles = [NSArray arrayWithObjects: @"Starts With", @"Contains", nil];
            break;
        }
    }
    b.delegate = self;
    [self.tableView setTableHeaderView:b];
    [self.tableView reloadData];
    [self.tableView 
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
     atScrollPosition:UITableViewScrollPositionTop animated:NO];
    UISearchDisplayController* c = 
    [[UISearchDisplayController alloc] initWithSearchBar:b 
                                      contentsController:self];
    self.sbc = c; // retain policy
    c.delegate = self;
    c.searchResultsDataSource = self;
    c.searchResultsDelegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (which) {
        case 1:
        case 2:
        {
            return 1;
            break;
        }
        case 3:
        case 4:
        {
            if (tableView == sbc.searchResultsTableView)
                return 1;
            return [sectionNames count];
            break;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    switch (which) {
        case 1:
        case 2:
        {
            return nil;
            break;
        }
        case 3:
        case 4:
        {
            if (tableView == sbc.searchResultsTableView)
                return nil;
            return [sectionNames objectAtIndex: section];
            break;
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    switch (which) {
        case 1:
        case 2:
        {
            return nil;
            break;
        }
        case 3:
        {
            if (tableView == sbc.searchResultsTableView)
                return nil;
            return sectionNames;
            break;
        }
        case 4:
        {
            if (tableView == sbc.searchResultsTableView)
                return nil;
            return [[NSArray arrayWithObject: UITableViewIndexSearch] 
                    arrayByAddingObjectsFromArray:sectionNames];
            break;
        }
    }

}


- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    switch (which) {
        case 1:
        case 2:
        {
            NSArray* model = 
            (tableView == sbc.searchResultsTableView) ? self.filteredStates : self.states;
            return [model count];
            break;
        }
        case 3:
        case 4:
        {   
            if (tableView == sbc.searchResultsTableView)
                return [self.filteredStates count];
            return [[sectionData objectAtIndex: section] count];
            break;
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:CellIdentifier];
    }
    switch (which) {
        case 1:
        case 2:
        {
            NSArray* model = 
            (tableView == sbc.searchResultsTableView) ? self.filteredStates : self.states;
            cell.textLabel.text = [model objectAtIndex: indexPath.row];
            break;
        }
        case 3:
        case 4:
        {
            if (tableView == sbc.searchResultsTableView) {
                cell.textLabel.text = [self.filteredStates objectAtIndex: indexPath.row];
            } else {
                NSString* s = 
                [[sectionData objectAtIndex: [indexPath section]] 
                 objectAtIndex: [indexPath row]];
                cell.textLabel.text = s;
            }
            break;
        }
    }
    return cell;
}

- (void) filterData { // for case 2 and 3, take scope buttons into account
    NSPredicate* p = [NSPredicate predicateWithBlock:
                      ^BOOL(id obj, NSDictionary *d) {
                          NSString* s = obj;
                          NSStringCompareOptions options = NSCaseInsensitiveSearch;
                          if (sbc.searchBar.selectedScopeButtonIndex == 0)
                              options |= NSAnchoredSearch;
                          return ([s rangeOfString:sbc.searchBar.text 
                                           options:options].location != NSNotFound);
                      }];
    self.filteredStates = [states filteredArrayUsingPredicate:p];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    switch (which) {
        case 1:
        {
            NSPredicate* p = [NSPredicate predicateWithBlock:
                              ^BOOL(id obj, NSDictionary *d) {
                                  NSString* s = obj;
                                  return ([s rangeOfString:searchText 
                                                   options:NSCaseInsensitiveSearch].location != NSNotFound);
                              }];
            self.filteredStates = [states filteredArrayUsingPredicate:p];
            break;
        }
        case 2:
        case 3:
        case 4:
        {
            [self filterData];
            break;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar 
selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self filterData];
}

- (NSInteger)tableView:(UITableView *)tableView 
sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index {
    switch (which) {
        case 1:
        case 2:
        case 3:
        {
            return index;
            break;
        }
        case 4:
        {
            if (index == 0)
                [tableView scrollRectToVisible:tableView.tableHeaderView.frame 
                                      animated:NO];
            return index-1;
            break;
        }
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (UIView* v in self.sbc.searchResultsTableView.subviews) {
            if ([v isKindOfClass: [UILabel class]] && [[(UILabel*)v text] isEqualToString:@"No Results"]) {
                [(UILabel*)v setText: @""];
                break;
            }
        }
    });
    return YES;
}


@end
