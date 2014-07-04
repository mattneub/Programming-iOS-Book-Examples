

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *noConstraintsView;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.noConstraintsView.translatesAutoresizingMaskIntoConstraints = YES;
}


- (IBAction)doButton:(UIGestureRecognizer*)g {
    CGPoint p = [g locationInView:g.view];
    UIView* v = [g.view hitTest:p withEvent:nil];
    if (!v || v == g.view)
        return;
    if (![NSStringFromClass([v class]) isEqualToString:@"MyView"])
        return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self grow:v];
    });
}

-(void)grow:(UIView*)v {
    NSLog(@"%@", @"grow");
    v.transform = CGAffineTransformScale(v.transform, 1.2, 1.2);
}


- (IBAction)growLayer:(UIGestureRecognizer*)g {
    NSLog(@"%@", @"growLayer");
    UIView* v = g.view;
    v.layer.transform = CATransform3DScale(v.layer.transform, 1.2, 1.2, 1);
}





@end
