

#import "RootViewController.h"
#import "MyHeaderView.h"

@interface RootViewController ()
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@property (nonatomic, strong) NSMutableSet* hiddenSections;
@end

@implementation RootViewController

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hiddenSections = [NSMutableSet new];
    
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
    [self.tableView registerClass:[MyHeaderView class] forHeaderFooterViewReuseIdentifier:@"Header"];

    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor redColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor blueColor];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if ([self.hiddenSections containsObject:@(section)])
        return 0;
    return [self.sectionData[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionNames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
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
    MyHeaderView* h =
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
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 2;
        [h addGestureRecognizer:tap];
    }
    UILabel* lab = (UILabel*)[h.contentView viewWithTag:1];
    lab.text = self.sectionNames[section];
    h.section = section;
    return h;
}

- (void) tap: (UIGestureRecognizer*) g {
    MyHeaderView* v = (id)g.view;
    
    NSInteger sec = v.section;
    NSUInteger ct = [(NSArray*)(self.sectionData)[sec] count];
    NSNumber* secnum = @(sec);
    if ([self.hiddenSections containsObject:secnum]) {
        [self.hiddenSections removeObject:secnum];
        [self.tableView beginUpdates];
        NSMutableArray* arr = [NSMutableArray array];
        for (int ix = 0; ix < ct; ix ++) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:ix inSection:sec];
            [arr addObject: ip];
        }
        [self.tableView insertRowsAtIndexPaths:arr
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[arr lastObject]
                              atScrollPosition:UITableViewScrollPositionNone
                                      animated:YES];
    } else {
        [self.hiddenSections addObject:secnum];
        [self.tableView beginUpdates];
        NSMutableArray* arr = [NSMutableArray array];
        for (int ix = 0; ix < ct; ix ++) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:ix inSection:sec];
            [arr addObject: ip];
        }
        [self.tableView deleteRowsAtIndexPaths:arr
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // NSLog(@"%@", view); // use this to prove we are reusing header views
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionNames;
}




@end
