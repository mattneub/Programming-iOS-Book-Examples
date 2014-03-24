
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize = CGSizeMake(150,50);
    UIView* v = [UIView new];
    v.backgroundColor = [UIColor yellowColor];
    // next line makes the whole background yellow, covering the background color
    // self.collectionView.backgroundView = v;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section {
    return 20;
}

// window background is white
// collection view background (from storyboard) is green

/*
 the window background never appears
 the collection view background appears when you "bounce" the scroll beyond its limits
 ...but is also visible behind all cells
 (I have not found a way to make the two different)
 the red cell background color is behind the cell
 the linen cell background view is on top of that
 the (translucent, here) selected background view is on top of that
 the content view and its contents are on top of that
 */

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                              forIndexPath:indexPath];
    if (!cell.backgroundView) { // brand new cell
        cell.backgroundColor = [UIColor redColor];
        
        UIImageView* v = [[UIImageView alloc] initWithFrame:cell.bounds];
        v.contentMode = UIViewContentModeScaleToFill;
        v.image = [UIImage imageNamed:@"linen.png"];
        cell.backgroundView = v;
        
        UIView* v2 = [[UIView alloc] initWithFrame:cell.bounds];
        v2.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1];
        cell.selectedBackgroundView = v2;
        
        UILabel* lab = [UILabel new];
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        lab.tag = 1;
        [cell.contentView addSubview:lab];
        [cell.contentView addConstraint:
         [NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [cell.contentView addConstraint:
         [NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        lab.textColor = [UIColor blackColor];
        lab.highlightedTextColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor clearColor];
    }
    UILabel* lab = (UILabel*)[cell viewWithTag:1];
    lab.text = [NSString stringWithFormat:@"Howdy there %ld", (long)indexPath.item];
    return cell;
}


@end
