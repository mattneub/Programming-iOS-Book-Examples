

#import "ViewController.h"
#import "MyLayer.h"

@interface ViewController ()
@property (nonatomic, strong) CALayer* layer;
@end

@implementation ViewController

- (IBAction)doButton:(id)sender {
    CALayer* layer = self.layer;
    
#define which 1
#if which == 1
    
    layer.position = CGPointMake(100,100); // proving that it normally works
    
#elif which == 2
    
    // turn off position animation for this layer
    [layer setValue:@YES forKey:@"suppressPositionAnimation"];
    layer.position = CGPointMake(100,100); // look Ma, no animation!

#elif which == 3
    
    // put a "position" entry into the layer's actions dictionary
    CABasicAnimation* ba = [CABasicAnimation animation];
    ba.duration = 5;
    layer.actions = @{@"position": ba};
    layer.delegate = nil; // use actions dictionary, not delegate
    
    // use implicit property animation
    CGPoint newP = CGPointMake(100,100);
    [CATransaction setAnimationDuration:1.5];
    layer.position = newP;
    // the animation "ba" will be used, with its 5-second duration

#elif which == 4
    
    layer.delegate = self;
    
    CGPoint newP = CGPointMake(300,300);
    [CATransaction setValue: [NSValue valueWithCGPoint: newP] forKey: @"newP"];
    [CATransaction setAnimationDuration:1.5];
    layer.position = newP;
    // the delegate will waggle the layer into place
    
#elif which == 5
    
    // layer automatically turns this into a push-from-left transition
    layer.contents = (id)[UIImage imageNamed:@"Smiley"].CGImage;
    
#elif which == 6

    layer = [CALayer new];
    layer.frame = CGRectMake(200,50,40,40);
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.contents = (id)[UIImage imageNamed:@"Smiley"].CGImage;
    layer.delegate = self;
    [self.view.layer addSublayer:layer];
    // the delegate will "pop" the layer as it appears
    
#elif which == 7

    layer.delegate = self;
    
    [CATransaction setCompletionBlock: ^{
        [layer removeFromSuperlayer];
    }];
    [CATransaction setValue:@"" forKey:@"byebye"];
    layer.opacity = 0;
    // the delegate will "shrink" the layer as it disappears
    
#elif which == 8
    
    // 8 is intended to supersede 7; I think this is a much neater way
    layer.delegate = self;
    [layer setValue:@"" forKey:@"farewell"];
    // the delegate will "shrink" the layer and remove it
    
#endif
    
    
    
}

- (id < CAAction >)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
    if ([key isEqualToString: @"position"]) {
        NSLog(@"%@", @"waggling");
        CGPoint oldP = layer.position;
        CGPoint newP = [[CATransaction valueForKey: @"newP"] CGPointValue];
        CGFloat d = sqrt(pow(oldP.x - newP.x, 2) + pow(oldP.y - newP.y, 2));
        CGFloat r = d/3.0;
        CGFloat theta = atan2(newP.y - oldP.y, newP.x - oldP.x);
        CGFloat wag = 10*M_PI/180.0;
        CGPoint p1 = CGPointMake(oldP.x + r*cos(theta+wag),
                                 oldP.y + r*sin(theta+wag));
        CGPoint p2 = CGPointMake(oldP.x + r*2*cos(theta-wag),
                                 oldP.y + r*2*sin(theta-wag));
        CAKeyframeAnimation* anim = [CAKeyframeAnimation animation];
        anim.values = @[[NSValue valueWithCGPoint:oldP],
                        [NSValue valueWithCGPoint:p1],
                        [NSValue valueWithCGPoint:p2],
                        [NSValue valueWithCGPoint:newP]];
        anim.calculationMode = kCAAnimationCubic;
        return anim;
    }
    if ([key isEqualToString:kCAOnOrderIn]) {
        CABasicAnimation* anim1 =
        [CABasicAnimation animationWithKeyPath:@"opacity"];
        anim1.fromValue = @0.0f;
        anim1.toValue = @(layer.opacity);
        CABasicAnimation* anim2 =
        [CABasicAnimation animationWithKeyPath:@"transform"];
        anim2.toValue = [NSValue valueWithCATransform3D:
                         CATransform3DScale(layer.transform, 1.2, 1.2, 1.0)];
        anim2.autoreverses = YES;
        anim2.duration = 0.1;
        CAAnimationGroup* group = [CAAnimationGroup animation];
        group.animations = @[anim1, anim2];
        group.duration = 0.2;
        return group;
    }
    if ([key isEqualToString:@"opacity"]) {
        if ([CATransaction valueForKey:@"byebye"]) {
            CABasicAnimation* anim1 =
            [CABasicAnimation animationWithKeyPath:@"opacity"];
            anim1.fromValue = @(layer.opacity);
            anim1.toValue = @0.0f;
            CABasicAnimation* anim2 =
            [CABasicAnimation animationWithKeyPath:@"transform"];
            anim2.toValue = [NSValue valueWithCATransform3D:
                             CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)];
            CAAnimationGroup* group = [CAAnimationGroup animation];
            group.animations = @[anim1, anim2];
            group.duration = 0.2;
            return group;
        }
    }
    if ([key isEqualToString:@"farewell"]) {
        CABasicAnimation* anim1 =
        [CABasicAnimation animationWithKeyPath:@"opacity"];
        anim1.fromValue = @(layer.opacity);
        anim1.toValue = @0.0f;
        CABasicAnimation* anim2 =
        [CABasicAnimation animationWithKeyPath:@"transform"];
        anim2.toValue = [NSValue valueWithCATransform3D:
                         CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)];
        CAAnimationGroup* group = [CAAnimationGroup animation];
        group.animations = @[anim1, anim2];
        group.duration = 0.2;
        group.delegate = self;
        [group setValue:layer forKey:@"remove"];
        layer.opacity = 0;
        return group;
    }

    return nil;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer* layer = [anim valueForKey:@"remove"];
    if (layer)
        [layer removeFromSuperlayer];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CALayer* layer = [MyLayer new];
    layer.frame = CGRectMake(50,50,40,40);
    [CATransaction setDisableActions:YES]; // prevent MyLayer automatic contents animation on next line
    layer.contents = (id)[UIImage imageNamed:@"Mars"].CGImage;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
}

@end
