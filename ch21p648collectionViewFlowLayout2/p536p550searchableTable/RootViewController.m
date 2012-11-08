

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Cell.h"
#import "MyFlowLayout.h"

@interface RootViewController ()

@property (nonatomic, strong) NSArray* states;
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@end

/*
Expand on the previous example to look decent, be more efficient
 */

@implementation RootViewController

-(void) createData {
    
    NSString* s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    self.states = [s componentsSeparatedByString:@"\n"];
    
    self.sectionNames = [NSMutableArray array];
    self.sectionData = [NSMutableArray array];
    NSString* previous = @"";
    for (NSString* aState in self.states) {
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

- (void) setUpFlowLayout: (UICollectionViewFlowLayout*) flow {
    flow.headerReferenceSize = CGSizeMake(50,50); // * larger - we will place label within this
    flow.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10); // *
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Switch" style:UIBarButtonItemStylePlain target:self action:@selector(doSwitch:)];
    self.navigationItem.leftBarButtonItem = b;
    
    b = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(doDelete:)];
    self.navigationItem.rightBarButtonItem = b;

    
    self.collectionView.backgroundColor = [UIColor whiteColor]; // *
    self.collectionView.allowsMultipleSelection = YES; // *
    
    // register cells
    [self.collectionView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    // register headers
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"Header"];
    //
    [self createData];
    self.navigationItem.title = @"States";
    //
    // if you don't do something about header size...
    // ...you won't see any headers
    UICollectionViewFlowLayout* flow = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    [self setUpFlowLayout:flow];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sectionNames count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [(self.sectionData)[section] count];
}

// headers

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView* v = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        if (![v.subviews count]) {
            UILabel* lab = [UILabel new]; // we will size it later
            [v addSubview: lab];
            lab.textAlignment = NSTextAlignmentCenter;
            // look nicer
            lab.font = [UIFont fontWithName:@"Georgia-Bold" size:22];
            lab.backgroundColor = [UIColor lightGrayColor];
            lab.layer.cornerRadius = 8;
            lab.layer.borderWidth = 2;
            lab.layer.borderColor = [UIColor blackColor].CGColor;
            NSDictionary* d = NSDictionaryOfVariableBindings(lab);
            lab.translatesAutoresizingMaskIntoConstraints = NO;
            [v addConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lab(35)]" options:0 metrics:nil views:d]];
            [v addConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lab(30)]-5-|" options:0 metrics:nil views:d]];
        }
        UILabel* lab = (UILabel*)v.subviews[0];
        lab.text = (self.sectionNames)[indexPath.section];
    }
    return v;
}

// cells

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell* cell = (Cell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if ([cell.lab.text isEqualToString:@"Label"]) {
        cell.layer.cornerRadius = 8;
        cell.layer.borderWidth = 2;
    }
    cell.lab.text = (self.sectionData)[indexPath.section][indexPath.row];
    NSString* stateName = cell.lab.text;
    
    // flag in background! very cute
    stateName = [stateName lowercaseString];
    stateName = [stateName stringByReplacingOccurrencesOfString:@" " withString:@""];
    stateName = [NSString stringWithFormat:@"flag_%@.gif", stateName];
    UIImage* im = [UIImage imageNamed: stateName];
    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
    cell.backgroundView = iv;
    
    // checkmark in top left corner when selected
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(cell.bounds.size.width, cell.bounds.size.height), NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    // sort of jumping ahead here, I'm going to use the new attributed string features of iOS 6
    NSShadow* shadow = [NSShadow new];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(2,2);
    shadow.shadowBlurRadius = 4;
    NSAttributedString* check2 =
    [[NSAttributedString alloc] initWithString:@"\u2714" attributes:@{
                           NSFontAttributeName: [UIFont fontWithName:@"ZapfDingbatsITC" size:24],
                NSForegroundColorAttributeName: [UIColor greenColor],
                    NSStrokeColorAttributeName: [UIColor redColor],
                    NSStrokeWidthAttributeName: @-4,
                         NSShadowAttributeName: shadow
     }];
    CGContextScaleCTM(con, 1.1, 1);
    [check2 drawAtPoint:CGPointMake(2,0)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    iv = [[UIImageView alloc] initWithImage:im];
    cell.selectedBackgroundView = iv;

    return cell;
}

// but the above is not sufficient to see the entire name of a state
// the state names are stepping on each other
// to fix that, we need to adjust the size of each cell, as a UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* arr = [[UINib nibWithNibName:@"Cell" bundle:nil] instantiateWithOwner:nil options:nil];
    Cell* cell = arr[0];
    cell.lab.text = (self.sectionData)[indexPath.section][indexPath.row];
    return [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

// selection
// we get automatic highlighting of whatever can be highlighted (i.e. our UILabel)
// we get automatic overlay of the selectedBackgroundView


// =====================

// can just change layouts on the fly! with built-in animation!!!

- (void) doSwitch:(id)sender {
    //CGPoint oldOffset = self.collectionView.contentOffset;
    UICollectionViewFlowLayout* oldLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    UICollectionViewFlowLayout* newLayout;
    newLayout = [oldLayout isKindOfClass:[MyFlowLayout class]] ?
    [UICollectionViewFlowLayout new] : [MyFlowLayout new];
    [self setUpFlowLayout:newLayout];
    [self.collectionView setCollectionViewLayout:newLayout animated:YES];
    //self.collectionView.contentOffset = oldOffset;
}

// =====================

- (void) doDelete:(id)sender {
    // delete selected
    NSArray* arr = [self.collectionView indexPathsForSelectedItems];
    if (!arr || ![arr count])
        return;
    // first update the model
    // not so easy! we don't get magical renumbering as we go
    // solution: form a dictionary of indexsets
    NSMutableIndexSet* empties = [NSMutableIndexSet indexSet];
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    for (NSIndexPath* ip in arr) {
        NSMutableIndexSet* set = d[@(ip.section)];
        if (!set) {
            d[@(ip.section)] = [NSMutableIndexSet indexSet];
            set = d[@(ip.section)];
        }
        [set addIndex:ip.item];
    }
    // now we can deal with each section in turn and delete all its selected items at once
    for (NSNumber* n in [d allKeys]) {
        NSMutableArray* marr = self.sectionData[[n integerValue]];
        [marr removeObjectsAtIndexes:d[n]];
        // also keep track of indexes of any sections that were emptied by doing that
        if (![marr count])
            [empties addIndex: [n integerValue]];
    }
    
    // finally, request the deletion from the view; notice the slick automatic animation
    [self.collectionView performBatchUpdates:^{ // so that we can proceed after completion
        [self.collectionView deleteItemsAtIndexPaths:arr];
    } completion:^(BOOL finished) {
        // now we are left with some possibly empty sections
        // if so, proceed to delete those as well (from both arrays at once)
        // this isn't the only way to solve the empty sections problem...
        // but it's fun to watch!
        if ([empties count]) {
            [self.sectionNames removeObjectsAtIndexes:empties];
            [self.sectionData removeObjectsAtIndexes:empties];
            [self.collectionView deleteSections:empties];
        }
    }];
}

// =========== menu ===========

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    // failed experiment
//    UIMenuItem* mi = [[UIMenuItem alloc] initWithTitle:@"Capital" action:@selector(capital:)];
//    [[UIMenuController sharedMenuController] setMenuItems:@[mi]];
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    // in real life, would do something here
}

@end
