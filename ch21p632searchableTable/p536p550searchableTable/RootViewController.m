

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GradientView:UIView
@end
@implementation GradientView
+(Class)layerClass {
    return [CAGradientLayer class];
}
@end


@interface RootViewController ()  <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchDisplayController* sbc;
@property (nonatomic, strong) NSArray* states;
@property (nonatomic, strong) NSArray* filteredStates;
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@end

@implementation RootViewController

-(void) createData { // not in nib any more so can't use awakeFromNib for this
    
    NSString* s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    self.states = [s componentsSeparatedByString:@"\n"];
    
    // compare p 618, sections
    // should replace example code there with this
    self.sectionNames = [NSMutableArray array];
    self.sectionData = [NSMutableArray array];
    NSString* previous = @"";
    for (NSString* aState in self.states) {
        // get the first letter
        NSString* c = [aState substringToIndex:1];
        // only add a letter to sectionNames when it's a different letter
        if (![c isEqualToString: previous]) {
            previous = c;
            [self.sectionNames addObject: [c uppercaseString]];
            // and in that case, also add a new array to our array of arrays
            NSMutableArray* oneSection = [NSMutableArray array];
            [self.sectionData addObject: oneSection];
        }
        [[self.sectionData lastObject] addObject: aState];
    }
}

#define which 4 // try also "2" for scope buttons, "3" for sections, "4" for sections with magnifying glass

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // register, the iOS 6 way
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // new iOS feature: register header and footer views as well!
    // a new class is provided to help us get started
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    // another new iOS feature: colorize index that runs down the right side
    self.tableView.sectionIndexColor = [UIColor greenColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor blackColor];
    //
    [self createData];
    self.navigationItem.title = @"States";
    UISearchBar* b = [UISearchBar new];
    [b sizeToFit];
    switch (which) {
        case 1: break;
        case 2:
        case 3:
        case 4:
        {
            b.scopeButtonTitles = @[@"Starts With", @"Contains"];
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

// here's a problem that's just arisen in iOS 6 (though I suppose it could have arisen earlier):
// how can I register a cell with the search display controller's table view?
// at my viewDidLoad time, that table view doesn't even exist yet
// solution is this method, which is effectively viewDidLoad for that table view
// this is also the place to do other table configurations, e.g. to make this table look like mine

// by the way, this shows why the new registration system is so great:
// I got a nice crash message telling me I'd failed to do this registration

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            if (tableView == self.sbc.searchResultsTableView)
                return 1;
            return [self.sectionNames count];
            break;
        }
    }
}

// new iOS 6 feature, built-in reusable header/footer views
// it suffices to implement this method!
// logging and the color prove we are reusing these views
// everything else works exactly as it did before...
// so our implementation of titleForHeader still works fine
// of course we *could* modify the view structure further here...
// ... but we don't; we are just using the built-in label
// and titleForHeader sets its text for us

// hmm, interesting: to suppress header entirely,
// we must not implement this method *at all*
// (tried returning nil but that failed to suppress the header)

// argh! but I can't use that trick to prevent the view from appearing in the search
// results table

#if (which==3 || which==4)

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView* h =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (![h.tintColor isEqual: [UIColor redColor]])
        NSLog(@"creating new header view"); // this will prove we're reusing views
    h.tintColor = [UIColor redColor]; // this will prove we're using these reusable views
    // hmmm, this next line fails!
    // things must be happening in the wrong order
    // h.textLabel.font = [UIFont fontWithName:@"Georgia" size:18];
    return h;
}

// further trick to prevent header view from appearing in search results table

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView != self.tableView) return 0;
    return UITableViewAutomaticDimension;
}

#endif

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
            if (tableView == self.sbc.searchResultsTableView)
                return nil;
            //NSLog(@"%@", [tableView headerViewForSection:section]);
            return (self.sectionNames)[section];
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
            if (tableView == self.sbc.searchResultsTableView)
                return nil;
            return self.sectionNames;
            break;
        }
        case 4:
        {
            if (tableView == self.sbc.searchResultsTableView)
                return nil;
            return [@[UITableViewIndexSearch] 
                    arrayByAddingObjectsFromArray:self.sectionNames];
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
            (tableView == self.sbc.searchResultsTableView) ? self.filteredStates : self.states;
            return [model count];
            break;
        }
        case 3:
        case 4:
        {   
            if (tableView == self.sbc.searchResultsTableView)
                return [self.filteredStates count];
            return [(self.sectionData)[section] count];
            break;
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell.backgroundView == nil) {
        // stuff that is in common for all cells can go here
        // added this stuff to illustrate how to make it *look* as if the two tables are the same
        UIView* v = [UIView new];
        v.backgroundColor = [UIColor blackColor];
        UIView* v2 = [GradientView new];
        CAGradientLayer* lay = (CAGradientLayer*)v2.layer;
        lay.colors = @[(id)[UIColor colorWithWhite:0.6 alpha:1].CGColor,
        (id)([UIColor colorWithWhite:0.4 alpha:1].CGColor)];
        lay.borderWidth = 1;
        lay.borderColor = [UIColor blackColor].CGColor;
        lay.cornerRadius = 5;
        [v addSubview:v2];
        v2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // or you could do the same thing with constraints, but there is no need
        cell.backgroundView = v;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    switch (which) {
        case 1:
        case 2:
        {
            NSArray* model = 
            (tableView == self.sbc.searchResultsTableView) ? self.filteredStates : self.states;
            cell.textLabel.text = model[indexPath.row];
            break;
        }
        case 3:
        case 4:
        {
            if (tableView == self.sbc.searchResultsTableView) {
                cell.textLabel.text = (self.filteredStates)[indexPath.row];
            } else {
                NSString* s = 
                (self.sectionData)[[indexPath section]][[indexPath row]];
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
                          if (self.sbc.searchBar.selectedScopeButtonIndex == 0)
                              options |= NSAnchoredSearch;
                          return ([s rangeOfString:self.sbc.searchBar.text
                                           options:options].location != NSNotFound);
                      }];
    self.filteredStates = [self.states filteredArrayUsingPredicate:p];
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
            self.filteredStates = [self.states filteredArrayUsingPredicate:p];
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
    dispatch_async(dispatch_get_main_queue(), ^(void){
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
