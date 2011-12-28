

/*
 New example, shameless plagiarized from the idea that Luke Hiesterman keeps showing
 in the WWDC videos.
 The idea here is to stress something that I failed to stress in the first edition:
 that table view interface can be manipulated in customized ways that make it a lot more
 than a mere table.
 Here, the section headers are double-clickable, and when you double-click one,
 its rows vanish or return in animated fashion.
 Thus we are using row insertion and deletion quite outside any user editing interface.
 This was very easy to manufacture by modifying our sectioned "states" example slightly.
 */

/*
 Also added example of new iOS 5 table cell menu display
 */

#import "RootViewController.h"
#import "MyCell.h"

@interface RootViewController () 
@property (nonatomic, strong) UISearchDisplayController* sbc;
@property (nonatomic, strong) NSArray* states;
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@property (nonatomic, strong) NSMutableSet* hiddenSections; // keep track of which are hidden
@property (nonatomic) BOOL aboutToShowMenu;
@end

@implementation RootViewController
@synthesize sbc, states, sectionNames, sectionData, hiddenSections, aboutToShowMenu;

-(void) createData { // not in nib any more so can't use awakeFromNib for this
    self.hiddenSections = [NSMutableSet set]; // initialize
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createData];
    self.navigationItem.title = @"States";
    
    // make interesting background
    UIImage* lin = [UIImage imageNamed: @"lin.png"];
    UIGraphicsBeginImageContext(CGSizeMake(40,40));
    [lin drawAtPoint:CGPointMake(-(lin.size.width - 40) / 2.0, -(lin.size.height - 40) / 2.0)];
    UIImage* lin2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* iv = [[UIImageView alloc] initWithImage:[lin2 resizableImageWithCapInsets:UIEdgeInsetsZero]];
    [self.tableView setBackgroundView:iv];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionNames count];
}

#define HHEIGHT 30

// instead of just text string, return a double-clickable label for the section headers
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel* lab = [[UILabel alloc] 
                    initWithFrame:CGRectMake(0,0,tableView.bounds.size.width, HHEIGHT)];
    lab.text = [NSString stringWithFormat:@"   %@", [sectionNames objectAtIndex: section]];
    lab.backgroundColor = [UIColor grayColor];
    lab.textColor = [UIColor whiteColor];
    lab.shadowColor = [UIColor blackColor];
    lab.shadowOffset = CGSizeMake(1,1);
    lab.userInteractionEnabled = YES;
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    t.numberOfTapsRequired = 2;
    [lab addGestureRecognizer:t];
    return lab;
}

// must provide height for header views
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HHEIGHT;
}

// check whether hidden or not; easy since it's all or none as to what rows are showing
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    if ([self.hiddenSections containsObject:[NSNumber numberWithUnsignedInteger:section]])
        return 0;
    return [[sectionData objectAtIndex: section] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    NSString* s = 
    [[sectionData objectAtIndex: [indexPath section]] 
     objectAtIndex: [indexPath row]];
    cell.textLabel.text = s;
    // comment out these next two lines and see how it affects what happens during menu display
    cell.textLabel.highlightedTextColor = cell.textLabel.textColor; // prevent white during menu
    // cell.selectedBackgroundView = [[UIView alloc] init]; // trick to prevent blue during menu display
    return cell;
}

// and here's what to do when the user double-clicks a header
- (void) tap: (UIGestureRecognizer*) g {
    UILabel* lab = (UILabel*)g.view;
    NSString* s = [lab.text substringFromIndex:3];
    NSUInteger sec = [self.sectionNames indexOfObject:s];
    NSUInteger ct = [(NSArray*)[self.sectionData objectAtIndex:sec] count];
    NSNumber* secnum = [NSNumber numberWithUnsignedInteger:sec];
    
    if ([self.hiddenSections containsObject:secnum]) {
        [self.hiddenSections removeObject:secnum];
        [self.tableView beginUpdates];
        NSMutableArray* arr = [NSMutableArray array];
        for (int ix = 0; ix < ct; ix ++) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:ix inSection:sec];
            [arr addObject: ip];
        }
        [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        // if necessary, scroll to make insertion visible
        [self.tableView scrollToRowAtIndexPath:[arr lastObject] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    } else {
        [self.hiddenSections addObject:secnum];
        [self.tableView beginUpdates];
        NSMutableArray* arr = [NSMutableArray array];
        for (int ix = 0; ix < ct; ix ++) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:ix inSection:sec];
            [arr addObject: ip];
        }
        [self.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

// ======= appended example of table cell menus; user must hold down on cell to summon
// note: must implement all three delegate methods, or messages are never sent

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    // play with menu
//    // failed experiment!
//    UIMenuItem* item = [[UIMenuItem alloc] initWithTitle:@"Capital" action:@selector(capital:)];
//    [[UIMenuController sharedMenuController] setMenuItems: [NSArray arrayWithObject:item]];
    
    // another experiment - trying to track menu-display state
    self.aboutToShowMenu = YES;
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    // as far as I can tell, only copy:, cut:, and paste: are eligible for display
    // this is a real pity: if true, you can't use your own menu items (I tried and failed)
//    NSLog(@"%@", NSStringFromSelector(action));
//    return (action == @selector(capital:));
    
    // another experiment
    self.aboutToShowMenu = NO;
    
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender 
{
    NSString* s = [[self.sectionData objectAtIndex: indexPath.section] objectAtIndex: indexPath.row]; 
    if (action == @selector(copy:)) {
        NSLog(@"in real life, we'd now copy %@ somehow", s);
    }
}



@end
