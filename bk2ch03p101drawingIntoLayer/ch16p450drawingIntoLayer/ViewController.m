
#import "ViewController.h"
#import "Smiler.h"
#import "Smiler2.h"
#import "SmilerLayer.h"
#import "SmilerLayer2.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray* views;
@property (nonatomic, strong) NSArray* smilers;
@end

@implementation ViewController

- (CALayer*) makeLayerOfClass: (Class) klass andAddToView: (int) ix {
    CALayer* lay = [klass new];
    lay.contentsScale = [[UIScreen mainScreen] scale];
//    lay.contentsGravity = kCAGravityBottom;
//    lay.contentsRect = (CGRect){{0.2,0.2}, {0.5,0.5}};
//    lay.contentsCenter = CGRectMake(0.0, 0.4, 1.0, 0.6);
    UIView* v = self.views[ix];
    lay.frame = v.layer.bounds;
    [v.layer addSublayer:lay];
    [lay setNeedsDisplay];
    
    // add another layer to say which view this is
    
    CATextLayer* tlay = [CATextLayer new];
    tlay.frame = lay.bounds;
    [lay addSublayer:tlay];
    tlay.string = [NSString stringWithFormat:@"%d", ix];
    tlay.fontSize = 30;
    tlay.alignmentMode = kCAAlignmentCenter;
    tlay.foregroundColor = [UIColor greenColor].CGColor;
    
    return lay;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.smilers = @[[Smiler new], [Smiler2 new]];
    
    // four ways of getting content into a layer
        
    // 0: delegate draws
    [self makeLayerOfClass:[CALayer class] andAddToView:0].delegate = self.smilers[0];
    // 1: delegate sets contents
    [self makeLayerOfClass:[CALayer class] andAddToView:1].delegate = self.smilers[1];
    // 2: subclass draws
    [self makeLayerOfClass:[SmilerLayer class] andAddToView:2];
    // 3: subclass sets contents
    [self makeLayerOfClass:[SmilerLayer2 class] andAddToView:3];

}


@end
