

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSArray *_objects;
}
@end

// almost entirely template code
// I got rid of editability of the table...
// and substituted a data model of pep boy names

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Testing";
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self->_objects = @[@"Manny", @"Moe", @"Jack"];
    // also may as well use this new iOS 6 feature
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self->_objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    id object = self->_objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = self->_objects[indexPath.row];
    self.detailViewController.detailItem = [object copy]; // making a copy just in case
}

@end
