

#import "MyLayout.h"

@implementation MyLayout {
    NSMutableArray* _atts;
    CGSize _sz;
}

-(void)prepareLayout {
    // how many items are there in total?
    int total = 0;
    NSInteger sections = [self.collectionView numberOfSections];
    for (int i = 0; i < sections; i++)
        total += [self.collectionView numberOfItemsInSection:i];
    
    // work out cell size based on bounds size
    CGSize sz = self.collectionView.bounds.size;
    CGFloat width = sz.width;
    int shortside = floor(width/50.0);
    CGFloat cellside = width/(float)shortside;
    
    // generate attributes for all cells
    int x = 0;
    int y = 0;
    NSMutableArray* atts = [NSMutableArray new];
    for (int i = 0; i < sections; i++) {
        NSInteger jj = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < jj; j++) {
            UICollectionViewLayoutAttributes* att =
            [UICollectionViewLayoutAttributes
             layoutAttributesForCellWithIndexPath:
             [NSIndexPath indexPathForItem:j
                                 inSection:i]];
            att.frame = CGRectMake(x*cellside,y*cellside,cellside,cellside);
            [atts addObject:att];
            x++;
            if (x >= shortside) {
                x = 0;
                y++;
            }
        }
    }
    self->_atts = atts;
    int fluff = (x == 0) ? 0 : 1;
    self->_sz = CGSizeMake(width, (y+fluff) * cellside);
}

- (CGSize)collectionViewContentSize {
    return self->_sz;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return newBounds.size.width != self->_sz.width;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes* att in self->_atts) {
        if ([att.indexPath isEqual:indexPath])
            return att;
    }
    return nil; // shouldn't happen
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self->_atts;
}

@end
