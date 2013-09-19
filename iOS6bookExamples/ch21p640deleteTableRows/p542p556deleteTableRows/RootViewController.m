

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, retain) NSMutableArray* sectionNames;
@property (nonatomic, retain) NSMutableArray* sectionData;
@end

@implementation RootViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // whole editability thing springs to life
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString* s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray* states = [s componentsSeparatedByString:@"\n"];
    
    self.sectionNames = [NSMutableArray array];
    self.sectionData = [NSMutableArray array];
    NSString* previous = @"";
    for (NSString* aState in states) {
        NSString* c = [aState substringToIndex:1];
        if (![c isEqualToString: previous]) {
            previous = c;
            [self.sectionNames addObject: [c uppercaseString]];
            NSMutableArray* oneSection = [NSMutableArray array];
            [self.sectionData addObject: oneSection];
        }
        [[self.sectionData lastObject] addObject: aState];
    }
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionNames count];
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    return (self.sectionNames)[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(self.sectionData)[section] count];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionNames;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    NSString* s = 
    (self.sectionData)[[indexPath section]][[indexPath row]];
    cell.textLabel.text = s;
    return cell;
}


// uncomment this to prevent the user from performing swipe-deletion without entering Edit mode explicitly
/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.editing ? 
    UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}
*/

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)ip {
    [(self.sectionData)[ip.section] 
     removeObjectAtIndex:ip.row];
    if ([(self.sectionData)[ip.section] count] == 0) {
        [self.sectionData removeObjectAtIndex: ip.section];
        [self.sectionNames removeObjectAtIndex: ip.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex: ip.section] 
                 withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadSectionIndexTitles]; // whoa! in iOS 5 this works! (previously was a no-op)
    } else {
        [tableView deleteRowsAtIndexPaths:@[ip]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



@end
