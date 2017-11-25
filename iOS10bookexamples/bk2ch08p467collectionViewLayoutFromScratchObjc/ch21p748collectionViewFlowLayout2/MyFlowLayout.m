

#import "MyFlowLayout.h"

@interface MyFlowLayout () <UICollisionBehaviorDelegate>
@property BOOL animating;
@property (nonatomic, strong) UIDynamicAnimator* animator;
@end

@implementation MyFlowLayout


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* arr = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes* atts in arr) {
        if (nil == atts.representedElementKind) {
            NSIndexPath* ip = atts.indexPath;
            atts.frame = [self layoutAttributesForItemAtIndexPath:ip].frame;
        }
    }
    
    // secret sauce for getting animation to work with a layout
    if (self.animating) {
        NSMutableArray* marr = [NSMutableArray new];
        for (UICollectionViewLayoutAttributes* atts in arr) {
            NSIndexPath* path = atts.indexPath;
            UICollectionViewLayoutAttributes* atts2 = nil;
            switch (atts.representedElementCategory) {
                case UICollectionElementCategoryCell: {
                    atts2 = [self.animator layoutAttributesForCellAtIndexPath:path];
                    break;
                }
                case UICollectionElementCategorySupplementaryView: {
                    NSString* kind = atts.representedElementKind;
                    atts2 = [self.animator layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:path];
                    break;
                }
                default:
                    break;
            }
            [marr addObject: (atts2 ? atts2 : atts)];
        }
        return marr;
    }

    
    return arr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* atts =
    [super layoutAttributesForItemAtIndexPath:indexPath];
    
    if (indexPath.item == 0) // degenerate case 1
        return atts;
    if (atts.frame.origin.x - 1 <= self.sectionInset.left) // degenerate case 2
        return atts;
    
    NSIndexPath* ipPrev =
    [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    
    CGRect fPrev = [self layoutAttributesForItemAtIndexPath:ipPrev].frame;
    CGFloat rightPrev = fPrev.origin.x + fPrev.size.width + self.minimumInteritemSpacing;
    CGRect f = atts.frame;
    f.origin.x = rightPrev;
    atts.frame = f;
    return atts;
}

- (void) flush {
    
    CGRect visworld = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    
    UIDynamicAnimator* anim = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.animator = anim;
    
    NSArray* atts = [self layoutAttributesForElementsInRect:visworld];
    self.animating = YES;
    
    UIGravityBehavior* grav = [[UIGravityBehavior alloc] initWithItems:atts];
    grav.action = ^{
        NSArray* atts = [self.animator itemsInRect:visworld];
        if (![atts count] || anim.elapsedTime > 4) {
            [self.animator removeAllBehaviors];
            self.animator = nil;
            // NSLog(@"%@", @"done");
            self.animating = NO;
            [self invalidateLayout];
        }
    };
    [anim addBehavior:grav];
    
    UICollisionBehavior* coll = [[UICollisionBehavior alloc] initWithItems:atts];
    CGPoint p1 = CGPointMake(CGRectGetMinX(visworld) + 150, CGRectGetMaxY(visworld));
    CGPoint p2 = CGPointMake(CGRectGetMaxX(visworld), CGRectGetMaxY(visworld));
    [coll addBoundaryWithIdentifier:@"bottom" fromPoint:p1 toPoint:p2];
    coll.collisionMode = UICollisionBehaviorModeBoundaries;
    coll.collisionDelegate = self;
    [anim addBehavior: coll];
    
    UIDynamicItemBehavior* beh = [[UIDynamicItemBehavior alloc] initWithItems:atts];
    beh.elasticity = 0.8;
    beh.friction = 0.1;
    [anim addBehavior: beh];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    UIPushBehavior* push = [[UIPushBehavior alloc] initWithItems:@[item] mode:UIPushBehaviorModeContinuous];
    [push setAngle:3*M_PI/4.0 magnitude:1.5];
    [self.animator addBehavior:push];
}


@end
