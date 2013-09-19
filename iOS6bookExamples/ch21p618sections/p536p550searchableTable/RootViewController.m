

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@end

@implementation RootViewController

-(void) createData { // not in nib any more so can't use awakeFromNib for this
    
    NSString* s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
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
            // and in that case, also add a new array to our array of arrays
            NSMutableArray* oneSection = [NSMutableArray array];
            [self.sectionData addObject: oneSection];
        }
        [[self.sectionData lastObject] addObject: aState];
    }
}

/*
 HeaderFooterView is like a basic cell: it has a backgroundView behind a contentView,
 and a textLabel plus detailTextLabel, and if you don't want to use those,
 you can add your own content to the contentView. That's all there is to it! (Except for tint.)
 You can subclass it. You can register it by class or by nib.
 */

// warning: detailTextLabel seems broken; it never appears


- (void)viewDidLoad
{
    [super viewDidLoad];
    // register, the iOS 6 way
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // new iOS feature: register header and footer views as well!
    // a new class is provided to help us get started
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    // another new iOS feature: colorize index that runs down the right side
    self.tableView.sectionIndexColor = [UIColor greenColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor blackColor];
    //
    [self createData];
    self.navigationItem.title = @"States";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionNames count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView* h =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (![h.tintColor isEqual: [UIColor redColor]]) {
        NSLog(@"creating new header view"); // this will prove we're reusing views
        // it works; we're creating only about 6 views
        h.tintColor = [UIColor redColor]; // this will prove we're using these reusable views
        
        // this next line actually overrides the tinting we just set
        // delete "contentView" to get a deprecation message!
        // you are not supposed to set the backgroundColor directly
        //h.contentView.backgroundColor = [UIColor redColor];
        // so, let's have a little fun
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
        
        // I wasn't able to set up a constraint between the image view and the built-in text label
        // this may be because the built-in text label isn't really a subview at this time
        // LATER: aha, I figured out why: the built-in text label is not in the content view
        // the lesson is probably that you can't really mix and match
        // I changed the code so I no longer do that
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [h.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[lab(25)]-10-[v(40)]"
                                                 options:0 metrics:nil
                                                   views:@{@"v":v, @"lab":lab}]];
        [h.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|"
                                                 options:0 metrics:nil
                                                   views:@{@"v":v}]];
        [h.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lab]|"
                                                 options:0 metrics:nil
                                                   views:@{@"lab":lab}]];


    }
    UILabel* lab = (UILabel*)[h.contentView viewWithTag:1];
    lab.text = self.sectionNames[section];
//    NSString* stateName = (self.sectionData)[section][0]; // use first state of section
//    stateName = [stateName lowercaseString];
//    stateName = [stateName stringByReplacingOccurrencesOfString:@" " withString:@""];
//    stateName = [NSString stringWithFormat:@"flag_%@.gif", stateName];
//    UIImage* im = [UIImage imageNamed: stateName];
//    UIImageView* iv = (UIImageView*)[h.contentView viewWithTag:2];
//    iv.image = im;
    return h;
}


// these "did end displaying" events are new in iOS 6 (header, footer, and even cell)
// presumably you could use them for some sort of dynamic efficiency?

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    // uncomment next line to get messages each time a header view scrolls out of view
    // NSLog(@"stopped displaying %i", section);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionNames;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [(self.sectionData)[section] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString* s = self.sectionData[indexPath.section][indexPath.row];
    cell.textLabel.text = s;
    
    NSString* stateName = s;
    stateName = [stateName lowercaseString];
    stateName = [stateName stringByReplacingOccurrencesOfString:@" " withString:@""];
    stateName = [NSString stringWithFormat:@"flag_%@.gif", stateName];
    UIImage* im = [UIImage imageNamed: stateName];
    cell.imageView.image = im;
    
    return cell;
}



@end
