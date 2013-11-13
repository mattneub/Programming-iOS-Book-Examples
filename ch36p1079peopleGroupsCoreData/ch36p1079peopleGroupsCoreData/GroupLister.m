

#import "GroupLister.h"
#import "PeopleLister.h"
#import "AppDelegate.h"
#import "NSManagedObject+GroupAndPerson.h"

@interface GroupLister () <UIAlertViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController* frc;
@end

@implementation GroupLister

- (void) viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* b =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
     target:self action:@selector(doAdd:)];
    self.navigationItem.rightBarButtonItem = b;
    UIBarButtonItem* b2 =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
     target:self action:@selector(doRefresh:)];
    self.navigationItem.leftBarButtonItem = b;
    self.navigationItem.rightBarButtonItem = b2;
    self.title = @"Groups";
    // no need to register cell; it comes from the storyboard
    // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

// getter for fetched results controller, pretty much boilerplate from template
- (NSFetchedResultsController *)frc {
    if (_frc != nil) {
        return _frc;
    }
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Group"
                inManagedObjectContext:self.managedObjectContext];
    req.entity = entity;
    req.fetchBatchSize = 20;
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    req.sortDescriptors = @[sortDescriptor];
    
    NSFetchedResultsController *afrc =
    [[NSFetchedResultsController alloc]
     initWithFetchRequest:req
     managedObjectContext:self.managedObjectContext
     sectionNameKeyPath:nil
     cacheName:@"Groups"];
    afrc.delegate = self;
    self.frc = afrc;
    
	NSError *error = nil;
	if (![self.frc performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _frc;
}


- (void) doRefresh: (id) sender {
    // currently a no-op
}

- (void) doAdd: (id) sender {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"New Group" message:@"Enter name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[av textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [av show];
}
    
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex])
        return;
    NSString* name = [alertView textFieldAtIndex:0].text;
    if (!name)
        return;
    if ([name isEqualToString: @""])
        return;
    NSManagedObjectContext *context = self.frc.managedObjectContext;
    NSEntityDescription *entity = self.frc.fetchRequest.entity;
    NSManagedObject *mo =
    [NSEntityDescription insertNewObjectForEntityForName:entity.name
                                  inManagedObjectContext:context];
    mo.name = name;
    mo.uuid = [[NSUUID UUID] UUIDString];
    mo.timestamp = [NSDate date];
    
    // save context
    NSError *error = nil;
    BOOL ok = [context save:&error];
    if (!ok) {
        NSLog(@"%@", error);
        return;
    }
    PeopleLister* pl = [[PeopleLister alloc] initWithNibName:@"PeopleLister" bundle:nil groupManagedObject:mo];
    [self.navigationController pushViewController:pl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


#pragma mark - Table view data source

// all pretty much boilerplate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return sectionInfo.numberOfObjects;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSManagedObject *object = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = object.name;
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeopleLister* pl = [[PeopleLister alloc] initWithNibName:@"PeopleLister" bundle:nil groupManagedObject:[self.frc objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:pl animated:YES];
}
 

@end
