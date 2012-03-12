

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, retain) NSMutableArray* sectionNames;
@property (nonatomic, retain) NSMutableArray* sectionData;
@end

@implementation RootViewController
@synthesize sectionData, sectionNames;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString* s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray* states = [s componentsSeparatedByString:@"\n"];
    
    // compare p 523, sections
    self.sectionNames = [NSMutableArray array];
    self.sectionData = [NSMutableArray array];
    NSString* previous = @"";
    for (NSString* aState in states) {
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


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionNames count];
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    return [sectionNames objectAtIndex: section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sectionData objectAtIndex: section] count];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sectionNames;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSString* s = 
    [[sectionData objectAtIndex: [indexPath section]] 
     objectAtIndex: [indexPath row]];
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
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self.sectionData objectAtIndex: indexPath.section] 
     removeObjectAtIndex:indexPath.row];
    if ([[self.sectionData objectAtIndex: indexPath.section] count] == 0) {
        [self.sectionData removeObjectAtIndex: indexPath.section];
        [self.sectionNames removeObjectAtIndex: indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex: indexPath.section] 
                 withRowAnimation:UITableViewRowAnimationLeft];
        [tableView reloadSectionIndexTitles]; // whoa! in iOS 5 this works! (previously was a no-op)
    } else {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationLeft];
    }
}



@end
