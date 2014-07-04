

#import "PeopleLister.h"
#import "Person.h"
#import "PeopleDocument.h"

@interface PeopleLister () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray* people;
@property (nonatomic, strong) PeopleDocument* doc;
@property (nonatomic, strong) NSURL* fileURL;

@end

@implementation PeopleLister

- (id) initWithNibName:(NSString *)nibNameOrNil 
                bundle:(NSBundle *)nibBundleOrNil 
               fileURL: (NSURL*) fileURL {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->_fileURL = fileURL;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return nil; // we must not exist without a fileURL
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.fileURL.lastPathComponent stringByDeletingPathExtension];
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAdd:)];
    self.navigationItem.rightBarButtonItems = @[b];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"Person"];
    
    NSFileManager* fm = [NSFileManager new];
    self.doc = [[PeopleDocument alloc] initWithFileURL:self.fileURL];
    void (^listPeople) (BOOL) = ^(BOOL success) {
        if (success) {
            self.people = self.doc.people;
            [self.tableView reloadData];
        }
    };
    if (![fm fileExistsAtPath:[self.fileURL path]])
        [self.doc saveToURL:self.doc.fileURL
           forSaveOperation:UIDocumentSaveForCreating 
          completionHandler:listPeople];
    else
        [self.doc openWithCompletionHandler:listPeople];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(docChanged:) name:UIDocumentStateChangedNotification object:self.doc];
}

- (void) docChanged: (id) sender {
    // need to be a lot more sophisticated about this
    NSLog(@"state: %lu", (unsigned long)self.doc.documentState);
    if (self.doc.documentState == UIDocumentStateNormal) {
        [self.tableView endEditing:YES];
        self.people = self.doc.people;
        [self.tableView reloadData];
    }
}

- (void) doAdd: (id) sender {
    [self.tableView endEditing:YES];
    Person* newP = [Person new];
    [self.people addObject: newP];
    NSInteger ct = [self.people count];
    NSIndexPath* ix = [NSIndexPath indexPathForRow:ct-1 inSection:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:ix atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:ix];
    UITextField* tf = (UITextField*)[cell viewWithTag:1];
    [tf becomeFirstResponder];
    
    [self.doc updateChangeCount:UIDocumentChangeDone];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.people)
        return 0; // no data yet
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.people count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:@"Person" forIndexPath:indexPath];
    UITextField* first = (UITextField*)[cell viewWithTag:1];
    UITextField* last = (UITextField*)[cell viewWithTag:2];
    Person* p = (self.people)[indexPath.row];
    first.text = p.firstName;
    last.text = p.lastName;
    first.delegate = last.delegate = self;
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"did end");
    UIView* v = textField.superview;
    while (![v isKindOfClass: [UITableViewCell class]])
        v = v.superview;
    UITableViewCell* cell = (UITableViewCell*)v;
    NSIndexPath* ip = [self.tableView indexPathForCell:cell];
    NSInteger row = ip.row;
    Person* p = (self.people)[row];
    [p setValue:textField.text forKey: ((textField.tag == 1) ? @"firstName" : @"lastName")];

    [self.doc updateChangeCount:UIDocumentChangeDone];
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView endEditing:YES];
    [self.people removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] 
                     withRowAnimation:UITableViewRowAnimationAutomatic];

    [self.doc updateChangeCount:UIDocumentChangeDone];
}

- (void) forceSave: (id) n {
    NSLog(@"forceSave");
    [self.tableView endEditing:YES];
    [self.doc saveToURL:self.doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceSave:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self forceSave: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


@end
