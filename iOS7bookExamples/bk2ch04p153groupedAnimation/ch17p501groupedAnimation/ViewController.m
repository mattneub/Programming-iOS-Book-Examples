

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIView *v;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.v = [[UIView alloc] initWithFrame:CGRectMake(254,28,56,38)];
    [self.view addSubview: self.v];
    self.v.layer.contents = (id)[[UIImage imageNamed:@"boat.gif"] CGImage];
    self.v.layer.contentsGravity = kCAGravityResizeAspectFill;
}

- (IBAction)doButton:(id)sender {
    [self animate];
}

- (void) animate {
    CGFloat h = 200;
    CGFloat v = 75;
    CGMutablePathRef path = CGPathCreateMutable();
    int leftright = 1;
    CGPoint next = self.v.layer.position;
    CGPoint pos;
    CGPathMoveToPoint(path, nil, next.x, next.y);
    for (int i = 0; i < 4; i++) {
        pos = next;
        leftright *= -1;
        next = CGPointMake(pos.x+h*leftright, pos.y+v);
        CGPathAddCurveToPoint(path, nil, pos.x, pos.y+30, next.x, next.y-30,
                              next.x, next.y);
    }
    CAKeyframeAnimation* anim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim1.path = path;
    CGPathRelease(path);
    anim1.calculationMode = kCAAnimationPaced;
    
    NSArray* revs = @[@0.0f,
                      @M_PI,
                      @0.0f,
                      @M_PI];
    CAKeyframeAnimation* anim2 =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim2.values = revs;
    anim2.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateY];
    anim2.calculationMode = kCAAnimationDiscrete;
    
    NSArray* pitches = @[@0.0f,
                         @(M_PI/60.0),
                         @0.0f,
                         @(-M_PI/60.0),
                         @0.0f];
    CAKeyframeAnimation* anim3 =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim3.values = pitches;
    anim3.repeatCount = HUGE_VALF;
    anim3.duration = 0.5;
    anim3.additive = YES;
    anim3.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[anim1, anim2, anim3];
    group.duration = 8;
    [self.v.layer addAnimation:group forKey:nil];
    [CATransaction setDisableActions:YES];
    self.v.layer.position = next;
}


@end
