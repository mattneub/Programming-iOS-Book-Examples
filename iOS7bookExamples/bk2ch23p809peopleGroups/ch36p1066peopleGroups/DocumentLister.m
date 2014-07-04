

#import "DocumentLister.h"
#import "PeopleLister.h"
#import "AppDelegate.h"

@interface DocumentLister () <UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray* files;
@end

@implementation DocumentLister

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void) doRefresh: (id) sender {
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory 
                                inDomain:NSUserDomainMask
                       appropriateForURL:nil create:NO error:nil];
    NSURL* ubiq = [(AppDelegate*)[[UIApplication sharedApplication] delegate] ubiq];
    if (ubiq)
        docsurl = ubiq;
    NSDirectoryEnumerator* dir = [fm enumeratorAtURL:docsurl
                          includingPropertiesForKeys:nil options:0
                                        errorHandler:nil];
    self.files = [NSMutableArray array];
    for (NSURL* aFile in dir) {
        [dir skipDescendants];
        if ([[aFile pathExtension] isEqualToString:@"pplgrp"])
            [self.files addObject:aFile];
    }
    [self.tableView reloadData];
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
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory 
                                inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL* ubiq = [(AppDelegate*)[[UIApplication sharedApplication] delegate] ubiq];
    if (ubiq)
        docsurl = ubiq;
    name = [name stringByAppendingPathExtension:@"pplgrp"];
    NSURL* url = [docsurl URLByAppendingPathComponent:name];
    if ([fm fileExistsAtPath:url.path])
        return; // TODO: would be nice to alert user to issue here
    PeopleLister* pl = [[PeopleLister alloc] initWithNibName:@"PeopleLister" bundle:nil fileURL:url];
    [self.navigationController pushViewController:pl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self doRefresh:nil];
    
    // good place to create NSMetadataQuery
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.files)
        return 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSURL* fileURL = (self.files)[indexPath.row];
    cell.textLabel.text = [fileURL.lastPathComponent stringByDeletingPathExtension];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeopleLister* pl = [[PeopleLister alloc] initWithNibName:@"PeopleLister" bundle:nil fileURL:(self.files)[indexPath.row]];
    [self.navigationController pushViewController:pl animated:YES];
}

@end
