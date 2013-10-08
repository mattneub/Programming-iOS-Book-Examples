

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray* states;
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@end

@implementation ViewController

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
    flow.headerReferenceSize = CGSizeMake(30,30);
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
            [v addSubview:[[UILabel alloc] initWithFrame:CGRectMake(0,0,30,30)]];
        }
        UILabel* lab = (UILabel*)v.subviews[0];
        lab.text = (self.sectionNames)[indexPath.section];
        lab.textAlignment = NSTextAlignmentCenter;
    }
    return v;
}

// cells

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (![cell.contentView.subviews count]) {
        [cell.contentView addSubview:[[UILabel alloc] initWithFrame:CGRectMake(0,0,30,30)]];
    }
    UILabel* lab = (UILabel*)cell.contentView.subviews[0];
    lab.text = (self.sectionData)[indexPath.section][indexPath.item]; // "item" synonym for "row"
    [lab sizeToFit];
    return cell;
}

// but the above is not sufficient to see the entire name of a state
// the state names are stepping on each other
// to fix that, we need to adjust the size of each cell, as a UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // note horrible duplication of code here
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,30,30)];
    lab.text = (self.sectionData)[indexPath.section][indexPath.item];
    [lab sizeToFit];
    return lab.bounds.size;
}


@end
