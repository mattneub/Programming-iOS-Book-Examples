

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CALayer* sprite;
@property (nonatomic, strong) NSArray* images;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(24,24), YES, 0);
        [[UIImage imageNamed: @"sprites.png"]
         drawAtPoint:CGPointMake(-(5+i)*24,-4*24)];
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [arr addObject: (id)im.CGImage];
    }
    for (int i = 1; i >= 0; i--) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(24,24), YES, 0);
        [[UIImage imageNamed: @"sprites.png"]
         drawAtPoint:CGPointMake(-(5+i)*24,-4*24)];
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [arr addObject: (id)im.CGImage];
    }
    self.images = [arr copy];
    self.sprite = [CALayer new];
    self.sprite.frame = CGRectMake(30,30,24,24);
    self.sprite.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:self.sprite];
    self.sprite.contents = self.images[0];
    
}

- (IBAction)doButton:(id)sender {
    
    
    CAKeyframeAnimation* anim = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    anim.values = self.images;
    anim.keyTimes = @[@0,@0.25,@0.5,@0.75,@1];
    anim.calculationMode = kCAAnimationDiscrete;
    anim.duration = 1.5;
    anim.repeatCount = HUGE_VALF;
    
    CABasicAnimation* anim2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anim2.duration = 10;
    anim2.toValue = [NSValue valueWithCGPoint: CGPointMake(350,30)];
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[anim, anim2];
    group.duration = 10;
    
    [self.sprite addAnimation:group forKey:nil];

    
}


@end
