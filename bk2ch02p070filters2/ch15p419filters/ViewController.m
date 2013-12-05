

#import "ViewController.h"
#import "MyVignetteFilter.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CIFilter* vig = [MyVignetteFilter new];
    CIImage* im = [CIImage imageWithCGImage:[UIImage imageNamed:@"Moi"].CGImage];
    [vig setValue:im forKey:@"inputImage"];
    CIImage* outim = vig.outputImage;
    
    // first way to generate the final bitmap image
    
#define which 2
#if which == 1
    
    CGImageRef moi3 =
    [[CIContext contextWithOptions:nil]
     createCGImage:outim
     fromRect:outim.extent];
    UIImage* moi4 = [UIImage imageWithCGImage:moi3];
    CGImageRelease(moi3);

    self.iv.image = moi4;
    
#elif which == 2
    
    UIGraphicsBeginImageContextWithOptions(outim.extent.size, NO, 0);
    [[UIImage imageWithCIImage:outim] drawInRect:outim.extent];
    UIImage* moi4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     
    self.iv.image = moi4;

#endif

}


@end
