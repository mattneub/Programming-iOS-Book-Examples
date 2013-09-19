

#import "ViewController.h"
#import "MyDropBounceAndRollBehavior.h"

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
    
    
    [self.anim addBehavior:[[MyDropBounceAndRollBehavior alloc] initWithView:self.iv]];
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"%@", @"pause");
}

-(void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    NSLog(@"%@", @"resume");
}


@end
