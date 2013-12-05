

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@property SEL originalEditAction;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"States";
    
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
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];

    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor redColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor blueColor];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem; // badda-bing, badda-boom
    
    // work around bug where section index partially obscures delete button
    
    self.originalEditAction = self.navigationItem.rightBarButtonItem.action;
    self.navigationItem.rightBarButtonItem.action = @selector(doEdit:);
}


- (void) doEdit: (id) sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSectionIndexTitles];
    });
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:self.originalEditAction withObject:sender];
#pragma clang diagnostic pop
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

#define which 2

#if which == 1

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return self.sectionNames[section];
}

#elif which == 2

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


#endif

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // NSLog(@"%@", view); // use this to prove we are reusing header views
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.editing)
        return nil;
    return self.sectionNames;
}


- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)ip {
    [self.sectionData[ip.section] removeObjectAtIndex:ip.row];
    if ([self.sectionData[ip.section] count] == 0) {
        [self.sectionData removeObjectAtIndex: ip.section];
        [self.sectionNames removeObjectAtIndex: ip.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex: ip.section]
                 withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadSectionIndexTitles];
    } else {
        [tableView deleteRowsAtIndexPaths:@[ip]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// prevent swipe-to-edit

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.editing ?
    UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}




@end
