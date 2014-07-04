

#import "MyDropBounceAndRollBehavior.h"

@interface MyDropBounceAndRollBehavior() <UICollisionBehaviorDelegate>
@property (nonatomic, strong) UIView* v;
@end

@implementation MyDropBounceAndRollBehavior

-(id)initWithView:(UIView*)v {
    self = [super init];
    if (self)
        self.v = v;
    return self;
}

-(void)willMoveToAnimator:(UIDynamicAnimator *)anim {
    if (!anim)
        return;
    UIView* sup = self.v.superview;
    
    UIGravityBehavior* grav = [UIGravityBehavior new];
    __weak MyDropBounceAndRollBehavior* wself = self;
    grav.action = ^{
        MyDropBounceAndRollBehavior* sself = wself;
        if (sself) {
            NSArray* items = [anim itemsInRect:sup.bounds];
            if (NSNotFound == [items indexOfObject:sself.v]) {
                [anim removeBehavior:sself];
                [sself.v removeFromSuperview];
                NSLog(@"%@", @"done");
            }
        }
    };
    [self addChildBehavior:grav];
    [grav addItem:self.v];
    
    UIPushBehavior* push = [[UIPushBehavior alloc] initWithItems:@[self.v] mode:UIPushBehaviorModeInstantaneous];
    push.pushDirection = CGVectorMake(2, 0);
    // [push setTargetOffsetFromCenter:UIOffsetMake(0, -200) forItem:self.iv];
    [self addChildBehavior:push];
    
    UICollisionBehavior* coll = [UICollisionBehavior new];
    coll.collisionMode = UICollisionBehaviorModeBoundaries;
    coll.collisionDelegate = self;
    [coll addBoundaryWithIdentifier:@"floor"
                          fromPoint:CGPointMake(0,sup.bounds.size.height)
                            toPoint:CGPointMake(sup.bounds.size.width,
                                                sup.bounds.size.height)];
    [self addChildBehavior:coll];
    [coll addItem:self.v];
    
    UIDynamicItemBehavior* bounce = [UIDynamicItemBehavior new];
    bounce.elasticity = 0.4;
    [self addChildBehavior:bounce];
    [bounce addItem:self.v];
}



-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    NSLog(@"%@", NSStringFromCGPoint(p));
    // look for the dynamic item behavior
    for (UIDynamicBehavior* b in self.childBehaviors) {
        if ([b isKindOfClass: [UIDynamicItemBehavior class]]) {
            UIDynamicItemBehavior* bounce = (UIDynamicItemBehavior*) b;
            CGFloat v = [bounce angularVelocityForItem:item];
            NSLog(@"%f", v);
            if (v <= 0.1) {
                NSLog(@"%@", @"adding angular velocity");
                [bounce addAngularVelocity:30 forItem:item];
            }
            break;
        }
    }
}

-(void)dealloc {
    NSLog(@"%@", @"dealloc");
}

@end
