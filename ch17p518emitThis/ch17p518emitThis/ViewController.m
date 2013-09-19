

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,10), NO, 1);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(con, CGRectMake(0,0,10,10));
    CGContextSetFillColorWithColor(con, [UIColor grayColor].CGColor);
    CGContextFillPath(con);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CAEmitterCell* cell = [CAEmitterCell emitterCell];
    cell.birthRate = 5;
    cell.lifetime = 1;
    cell.velocity = 100;
    cell.contents = (id)im.CGImage;
    
    CAEmitterLayer* emit = [CAEmitterLayer new];
    emit.emitterPosition = CGPointMake(30,100);
    emit.emitterShape = kCAEmitterLayerPoint;
    emit.emitterMode = kCAEmitterLayerPoints;

    emit.emitterCells = @[cell];
    [self.view.layer addSublayer:emit];
    
#define which 5
#if which >= 1
    
    cell.birthRate = 100;
    cell.lifetime = 1.5;
    cell.velocity = 100;
    cell.emissionRange = M_PI/5.0;
    
    cell.xAcceleration = -40;
    cell.yAcceleration = 200;
    
    cell.lifetimeRange = .4;
    cell.velocityRange = 20;
    cell.scaleRange = .2;
    cell.scaleSpeed = .2;

    cell.color = [UIColor blueColor].CGColor;
    cell.greenRange = .5;
    cell.greenSpeed = .75;
    
#endif
    
#if which >= 2

    cell.name = @"circle";
    [emit setValue:@3.0f
        forKeyPath:@"emitterCells.circle.greenSpeed"];

#endif
    
#if which >= 3
    
    NSString* key = @"emitterCells.circle.greenSpeed";
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:key];
    ba.fromValue = @-1.0f;
    ba.toValue = @3.0f;
    ba.duration = 4;
    ba.autoreverses = YES;
    ba.repeatCount = HUGE_VALF;
    [emit addAnimation:ba forKey:nil];
    
#endif
    
#if which >= 4
    
    CAEmitterCell* cell2 = [CAEmitterCell emitterCell];
    cell.emitterCells = @[cell2];
    cell2.contents = (id)im.CGImage;
    cell2.emissionRange = M_PI;
    cell2.birthRate = 200;
    cell2.lifetime = 0.4;
    cell2.velocity = 200;
    cell2.scale = 0.2;
    
//    cell2.beginTime = .04;
//    cell2.duration = .2;
    
    // these next two lines are not causing the same result on iOS 7 as on iOS 6
    // I have filed a bug on this
    
    cell2.beginTime = .7;
    cell2.duration = .8;
    
    // interestingly, it looks about right on iOS 7...
    // ... if we double the beginTime and halve the duration
    
    cell2.beginTime = 1.4;
    cell2.duration = .4;
    
#endif
    
#if which >= 5
    
    emit.emitterPosition = CGPointMake(100,25);
    emit.emitterSize = CGSizeMake(100,100);
    emit.emitterShape = kCAEmitterLayerLine;
    emit.emitterMode = kCAEmitterLayerOutline;
    cell.emissionLongitude = 3*M_PI/4;
    
    // new addition: might also be fun to animation position of source back and forth
    CABasicAnimation* ba2 = [CABasicAnimation animationWithKeyPath:@"emitterPosition"];
    ba2.fromValue = [NSValue valueWithCGPoint:CGPointMake(30,100)];
    ba2.toValue = [NSValue valueWithCGPoint:CGPointMake(200,100)];
    ba2.duration = 6;
    ba2.autoreverses = YES;
    ba2.repeatCount = HUGE_VALF;
    [emit addAnimation:ba2 forKey:nil];


    
#endif
    

}


@end
