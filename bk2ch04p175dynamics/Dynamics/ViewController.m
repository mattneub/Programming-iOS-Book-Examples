

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (strong, nonatomic) UIDynamicAnimator* anim;
@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.anim = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.anim.delegate = self;
}

- (IBAction)doButton:(id)sender {
    [(UIButton*)sender setEnabled:NO];
    
    UIGravityBehavior* grav = [UIGravityBehavior new];
    grav.action = ^{
        NSArray* items = [self.anim itemsInRect:self.view.bounds];
        if (NSNotFound == [items indexOfObject:self.iv]) {
            [self.anim removeAllBehaviors];
            [self.iv removeFromSuperview];
            NSLog(@"%@", @"done");
        }
    };
    [self.anim addBehavior:grav];
    [grav addItem:self.iv];
    
    UIPushBehavior* push = [[UIPushBehavior alloc] initWithItems:@[self.iv] mode:UIPushBehaviorModeInstantaneous];
    push.pushDirection = CGVectorMake(2, 0);
    // [push setTargetOffsetFromCenter:UIOffsetMake(0, -200) forItem:self.iv];
    [self.anim addBehavior:push];
    
    UICollisionBehavior* coll = [UICollisionBehavior new];
    coll.collisionMode = UICollisionBehaviorModeBoundaries;
    coll.collisionDelegate = self;
    [coll addBoundaryWithIdentifier:@"floor"
                          fromPoint:CGPointMake(0,self.view.bounds.size.height)
                            toPoint:CGPointMake(self.view.bounds.size.width,
                                                self.view.bounds.size.height)];
    [self.anim addBehavior:coll];
    [coll addItem:self.iv];

    UIDynamicItemBehavior* bounce = [UIDynamicItemBehavior new];
    bounce.elasticity = 0.4;
    [self.anim addBehavior:bounce];
    [bounce addItem:self.iv];
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    NSLog(@"%@", NSStringFromCGPoint(p));
    // look for the dynamic item behavior
    for (UIDynamicBehavior* b in self.anim.behaviors) {
        if ([b isKindOfClass: [UIDynamicItemBehavior class]]) {
            UIDynamicItemBehavior* bounce = (UIDynamicItemBehavior*) b;
            CGFloat v = [bounce angularVelocityForItem:self.iv];
            NSLog(@"%f", v);
            if (v <= 0.1) {
                NSLog(@"%@", @"adding angular velocity");
                [bounce addAngularVelocity:30 forItem:self.iv];
            }
            break;
        }
    }
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"%@", @"pause");
}

-(void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    NSLog(@"%@", @"resume");
}


@end
