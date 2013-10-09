

#import "ViewController.h"
#import "Cell.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray* states;
@property (nonatomic, strong) NSMutableArray* sectionNames;
@property (nonatomic, strong) NSMutableArray* sectionData;
@property (nonatomic, strong) Cell* modelCell;

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
    
    UIBarButtonItem* bb = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(doPush:)];
    self.navigationItem.rightBarButtonItem = bb;

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.allowsMultipleSelection = YES;
    
    // register cell, comes from a nib even though we are using a storyboard
    [self.collectionView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    // register headers
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"Header"];
    //
    [self createData];
    self.navigationItem.title = @"States";
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
    Cell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if ([cell.lab.text isEqualToString:@"Label"]) { // new cell
        cell.layer.cornerRadius = 8;
        cell.layer.borderWidth = 2;
        
        cell.backgroundColor = [UIColor grayColor];
        
        // checkmark in top left corner when selected
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(cell.bounds.size.width, cell.bounds.size.height), NO, 0);
        CGContextRef con = UIGraphicsGetCurrentContext();
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
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView* iv = [[UIImageView alloc] initWithImage:nil highlightedImage:im];
        iv.userInteractionEnabled = NO;
        [cell addSubview: iv];

    }
    cell.lab.text = (self.sectionData)[indexPath.section][indexPath.row];
    
    NSString* stateName = cell.lab.text;
    
    // flag in background! very cute
    stateName = [stateName lowercaseString];
    stateName = [stateName stringByReplacingOccurrencesOfString:@" " withString:@""];
    stateName = [NSString stringWithFormat:@"flag_%@.gif", stateName];
    UIImage* im = [UIImage imageNamed: stateName];
    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundView = iv;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.modelCell) {
        NSArray* arr = [[UINib nibWithNibName:@"Cell" bundle:nil] instantiateWithOwner:nil options:nil];
        self.modelCell = arr[0];
    }
    self.modelCell.lab.text = (self.sectionData)[indexPath.section][indexPath.row];
    CGSize sz = [self.modelCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    sz.width = ceil(sz.width) + 1.0;
    return sz;
}

// =====================

- (void) doPush:(id)sender {
    [self performSegueWithIdentifier:@"push" sender:self];
}



@end
