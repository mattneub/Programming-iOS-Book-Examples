
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* mars = [UIImage imageNamed:@"Mars"];
    
#define which 4
    
#if which == 1
    
    UIImage* marsTiled = [mars resizableImageWithCapInsets:UIEdgeInsetsZero
                                              resizingMode: UIImageResizingModeTile];
    
#elif which == 2
    
    UIImage* marsTiled = [mars resizableImageWithCapInsets:
                          UIEdgeInsetsMake(mars.size.height/4.0,
                                           mars.size.width/4.0,
                                           mars.size.height/4.0,
                                           mars.size.width/4.0)
                                              resizingMode: UIImageResizingModeTile];

#elif which == 3
    
    UIImage* marsTiled = [mars resizableImageWithCapInsets:
                          UIEdgeInsetsMake(mars.size.height/4.0,
                                           mars.size.width/4.0,
                                           mars.size.height/4.0,
                                           mars.size.width/4.0)
                                              resizingMode: UIImageResizingModeStretch];

#elif which == 4
    
    UIImage* marsTiled = [mars resizableImageWithCapInsets:
                          UIEdgeInsetsMake(mars.size.height/2.0 - 1,
                                           mars.size.width/2.0 - 1,
                                           mars.size.height/2.0 - 1,
                                           mars.size.width/2.0 - 1)
                                              resizingMode: UIImageResizingModeStretch];

#endif
    
    self.iv.image = marsTiled;



}


@end
