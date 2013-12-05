

#import "PeopleLister.h"
#import "NSManagedObject+GroupAndPerson.h"

@interface PeopleLister () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObject* groupObject;
@property (nonatomic, strong) NSFetchedResultsController* frc;

@end

@implementation PeopleLister

- (id) initWithNibName:(NSString *)nibNameOrNil 
                bundle:(NSBundle *)nibBundleOrNil 
               groupManagedObject: (NSManagedObject*) object {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->_groupObject = object;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return nil; // we must not exist without a group object
}


- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.groupObject.name;
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAdd:)];
    self.navigationItem.rightBarButtonItems = @[b];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"Person"];
}

- (NSFetchedResultsController *)frc {
    if (_frc != nil) {
        return _frc;
    }
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Person"
                inManagedObjectContext:self.groupObject.managedObjectContext];
    req.entity = entity;
    req.fetchBatchSize = 20;
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    req.sortDescriptors = @[sortDescriptor];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"group = %@", self.groupObject];
    req.predicate = pred;
    
    NSFetchedResultsController *afrc =
    [[NSFetchedResultsController alloc]
     initWithFetchRequest:req
     managedObjectContext:self.groupObject.managedObjectContext
     sectionNameKeyPath:nil
     cacheName:self.groupObject.uuid]; // prevent cache name conflicts
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.frc sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.frc sections][section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Person" forIndexPath:indexPath];
    NSManagedObject *object = [self.frc objectAtIndexPath:indexPath];
    UITextField* first = (UITextField*)[cell viewWithTag:1];
    UITextField* last = (UITextField*)[cell viewWithTag:2];
    first.text = object.firstName;
    last.text = object.lastName;
    first.delegate = last.delegate = self;
    return cell;
}

- (void) doAdd: (id) sender {
    [self.tableView endEditing:YES];
    NSManagedObjectContext *context = self.frc.managedObjectContext;
    NSEntityDescription *entity = self.frc.fetchRequest.entity;
    NSManagedObject *mo =
    [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    mo.group = self.groupObject;
    mo.lastName = @"";
    mo.firstName = @"";
    mo.timestamp = [NSDate date];
    // save context
    NSError *error = nil;
    BOOL ok = [context save:&error];
    if (!ok) {
        NSLog(@"%@", error);
        return;
    }
    // and the rest is in the update delegate messages
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    // NSLog(@"did end");
    UIView* v = textField.superview;
    while (![v isKindOfClass: [UITableViewCell class]])
        v = v.superview;
    UITableViewCell* cell = (UITableViewCell*)v;
    NSIndexPath* ip = [self.tableView indexPathForCell:cell];
    NSManagedObject* object = [self.frc objectAtIndexPath:ip];
    [object setValue:textField.text forKey: ((textField.tag == 1) ? @"firstName" : @"lastName")];
    
    // save context
    NSError *error = nil;
    BOOL ok = [object.managedObjectContext save:&error];
    if (!ok) {
        NSLog(@"%@", error);
        return;
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSManagedObjectContext *context = self.frc.managedObjectContext;
    // save context
    NSError *error = nil;
    BOOL ok = [context save:&error];
    if (!ok) {
        NSLog(@"%@", error);
        return;
    }
}

#pragma mark - Content Update

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        dispatch_async(dispatch_get_main_queue(), ^{ // wait for interface to settle
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:newIndexPath];
            UITextField* tf = (UITextField*)[cell viewWithTag:1];
            [tf becomeFirstResponder];
        });
    }
}


@end
