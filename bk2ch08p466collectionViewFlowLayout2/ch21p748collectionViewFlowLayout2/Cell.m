
#import "Cell.h"

@implementation Cell

-(void)capital:(id)sender {
    // find my collection view
    UIView* v = self;
    do {
        v = v.superview;
    } while (![v isKindOfClass:[UICollectionView class]]);
    UICollectionView* cv = (UICollectionView*) v;
    // ask it what index path we are
    NSIndexPath* ip = [cv indexPathForCell:self];
    // talk to its delegate
    if (cv.delegate && [cv.delegate respondsToSelector:
                        @selector(collectionView:performAction:forItemAtIndexPath:withSender:)])
        [cv.delegate collectionView:cv performAction:_cmd
             forItemAtIndexPath:ip withSender:sender];
}


@end
