

#import "RootViewController.h"

@interface RootViewController () <UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@property (nonatomic, strong) NSMutableArray* filteredSectionData;
@property (nonatomic, strong) UISearchDisplayController* sdc;
@end

@implementation RootViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(goSearch:)];
        self.navigationItem.rightBarButtonItem = b;
        self.navigationItem.title = @"States";
    }
    return self;
}
- (void) goSearch: (id) sender {
    [self.navigationController pushViewController:[RootViewController new] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* s =
    [NSString stringWithContentsOfFile:
     [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"]
                              encoding:NSUTF8StringEncoding error:nil];
    NSArray* states = [s componentsSeparatedByString:@"\n"];
    self.sectionNames = [NSMutableArray array];
    self.sectionData = [NSMutableArray array];
    NSString* previous = @"";
    for (NSString* aState in states) {
        // get the first letter
        NSString* c = [aState substringToIndex:1];
        // only add a letter to sectionNames when it's a different letter
        if (![c isEqualToString: previous]) {
            previous = c;
            [self.sectionNames addObject: [c uppercaseString]];
            // and in that case, also add a new subarray to our array of subarrays
            NSMutableArray* oneSection = [NSMutableArray array];
            [self.sectionData addObject: oneSection];
        }
        [[self.sectionData lastObject] addObject: aState];
    }

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];

    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor blackColor];
//    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor blueColor];
    
    self.tableView.backgroundColor = [UIColor yellowColor];
    
    if (self.navigationController.viewControllers.count > 1) {
        UISearchBar* b = [UISearchBar new];
        b.delegate = self;
        b.showsCancelButton = YES;
        b.autocapitalizationType = UITextAutocapitalizationTypeNone;
        UISearchDisplayController* c =
        [[UISearchDisplayController alloc] initWithSearchBar:b
                                          contentsController:self];
        self.sdc = c; // retain the UISearchDisplayController
        c.delegate = self;
        c.searchResultsDataSource = self;
        c.searchResultsDelegate = self;
        c.displaysSearchBarInNavigationBar = YES;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%@", @"number of sections");
    return [self.sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of rows in section %ld", (long)section);
    NSArray* model =
    (tableView == self.sdc.searchResultsTableView) ?
    self.filteredSectionData : self.sectionData;
    return [model[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell for section %ld row %ld", (long)indexPath.section, (long)indexPath.row);
    UITableViewCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:@"Cell"
                                    forIndexPath:indexPath];
    NSArray* model =
    (tableView == self.sdc.searchResultsTableView) ?
    self.filteredSectionData : self.sectionData;
    NSString* s = model[indexPath.section][indexPath.row];
    cell.textLabel.text = s;
    
    // this part is not in the book, it's just for fun
    NSString* stateName = s;
    stateName = [stateName lowercaseString];
    stateName = [stateName stringByReplacingOccurrencesOfString:@" " withString:@""];
    stateName = [NSString stringWithFormat:@"flag_%@.gif", stateName];
    UIImage* im = [UIImage imageNamed: stateName];
    cell.imageView.image = im;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSLog(@"view for header %ld", (long)section);
    
    UITableViewHeaderFooterView* h =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (![h.tintColor isEqual: [UIColor redColor]]) {
        h.tintColor = [UIColor redColor]; // invisible marker
        h.backgroundView = [UIView new];
        h.backgroundView.backgroundColor = [UIColor redColor];
        UILabel* lab = [UILabel new];
        lab.tag = 1;
        lab.font = [UIFont fontWithName:@"Georgia-Bold" size:22];
        lab.textColor = [UIColor greenColor];
        lab.backgroundColor = [UIColor clearColor];
        [h.contentView addSubview:lab];
        UIImageView* v = [UIImageView new];
        v.tag = 2;
        v.backgroundColor = [UIColor blackColor];
        v.image = [UIImage imageNamed:@"us_flag_small.gif"];
        [h.contentView addSubview:v];
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [h.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-5-[lab(25)]-10-[v(40)]"
          options:0 metrics:nil views:@{@"v":v, @"lab":lab}]];
        [h.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[v]|"
          options:0 metrics:nil views:@{@"v":v}]];
        [h.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[lab]|"
          options:0 metrics:nil views:@{@"lab":lab}]];
    }
    UILabel* lab = (UILabel*)[h.contentView viewWithTag:1];
    lab.text = self.sectionNames[section];
    return h;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    
    // configure search results table to look like our table
    
    tableView.backgroundColor = [UIColor yellowColor];
    
    // suppress section headers
    
    tableView.sectionHeaderHeight = 0;

}

// this is it, Arthur Pewty!

- (void) filterData: (UISearchBar*) sb {
    // this is the search criteria
    NSPredicate* p = [NSPredicate predicateWithBlock:
                      ^BOOL(id obj, NSDictionary *d) {
                          NSString* s = obj;
                          NSStringCompareOptions options = NSCaseInsensitiveSearch;
                          return ([s rangeOfString:sb.text
                                           options:options].location != NSNotFound);
                      }];
    NSMutableArray* filteredData = [NSMutableArray new];
    // sectionData is an array of arrays
    // for every array ...
    for (NSMutableArray* arr in self.sectionData) {
        // generate an array of strings passing the search criteria
        [filteredData addObject: [arr filteredArrayUsingPredicate:p]];
    }
    self.filteredSectionData = filteredData;

}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    [self filterData: searchBar];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        for (UIView* v in controller.searchResultsTableView.subviews) {
            if ([v isKindOfClass: [UILabel class]] &&
                [[(UILabel*)v text] isEqualToString:@"No Results"]) {
                [(UILabel*)v setText: @""];
                break;
            }
        }
    });
    return YES;
}



@end
