

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Cell.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor]; // *
    
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
    flow.headerReferenceSize = CGSizeMake(50,50); // * larger - we will place label within this
    flow.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10); // *
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
    cell.lab.text = (self.sectionData)[[indexPath section]][[indexPath row]];
    NSString* stateName = cell.lab.text;
    stateName = [stateName lowercaseString];
    stateName = [stateName stringByReplacingOccurrencesOfString:@" " withString:@""];
    stateName = [NSString stringWithFormat:@"flag_%@.gif", stateName];
    UIImage* im = [UIImage imageNamed: stateName];
    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
    cell.backgroundView = iv;

    return cell;
}

// but the above is not sufficient to see the entire name of a state
// the state names are stepping on each other
// to fix that, we need to adjust the size of each cell, as a UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* arr = [[UINib nibWithNibName:@"Cell" bundle:nil] instantiateWithOwner:nil options:nil];
    Cell* cell = arr[0];
    cell.lab.text = (self.sectionData)[[indexPath section]][[indexPath row]];
    //[cell layoutIfNeeded];
    //return cell.bounds.size;
    return [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end
