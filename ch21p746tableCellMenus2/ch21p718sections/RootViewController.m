

#import "RootViewController.h"
#import "MyCell.h"

@interface RootViewController ()
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@end

@implementation RootViewController

-(BOOL)prefersStatusBarHidden {
    return YES;
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

    [self.tableView registerClass:[MyCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];

    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor redColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor blueColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [(self.sectionData)[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                    forIndexPath:indexPath];
    NSString* s = self.sectionData[indexPath.section][indexPath.row];
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
    UITableViewHeaderFooterView* h =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (![h.tintColor isEqual: [UIColor redColor]]) {
        h.tintColor = [UIColor redColor]; // invisible marker
        h.backgroundView = [UIView new];
        h.backgroundView.backgroundColor = [UIColor blackColor];
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

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // NSLog(@"%@", view); // use this to prove we are reusing header views
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionNames;
}

// menu handling ==========

- (BOOL)tableView:(UITableView *)tableView
shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    // extra menu item
    UIMenuItem* mi =
    [[UIMenuItem alloc] initWithTitle:@"Abbrev" action:NSSelectorFromString(@"abbrev:")];
    [[UIMenuController sharedMenuController] setMenuItems:@[mi]];
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action
forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return (action == NSSelectorFromString(@"copy:") ||
            action == NSSelectorFromString(@"abbrev:"));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action
forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSString* s = self.sectionData[indexPath.section][indexPath.row];
    if (action == NSSelectorFromString(@"copy:")) {
        // ... do whatever copying consists of ...
        NSLog(@"copying %@", s);
    }
    if (action == NSSelectorFromString(@"abbrev:")) {
        // ... do whatever abbreviating consists of ...
        NSLog(@"abbreviating %@", s);
    }
}


@end
