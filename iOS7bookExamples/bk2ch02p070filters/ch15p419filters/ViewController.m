

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage* moi = [UIImage imageNamed:@"Moi"];
    CIImage* moi2 = [[CIImage alloc] initWithCGImage:moi.CGImage];
    CGRect moiextent = moi2.extent;
    
    CIFilter* grad = [CIFilter filterWithName:@"CIRadialGradient"];
    CIVector* center = [CIVector vectorWithX:moiextent.size.width/2.0
                                           Y:moiextent.size.height/2.0];
    [grad setValue:center forKey:@"inputCenter"];
    [grad setValue:@85 forKey:@"inputRadius0"];
    [grad setValue:@100 forKey:@"inputRadius1"];
    CIImage *gradimage = [grad valueForKey: @"outputImage"];
    
    CIFilter* blend = [CIFilter filterWithName:@"CIBlendWithMask"];
    [blend setValue:moi2 forKey:@"inputImage"];
    [blend setValue:gradimage forKey:@"inputMaskImage"];
    
    // first way to generate the final bitmap image
    
#define which 1
#if which == 1
    
    CGImageRef moi3 =
    [[CIContext contextWithOptions:nil]
     createCGImage:blend.outputImage
     fromRect:moiextent];
    UIImage* moi4 = [UIImage imageWithCGImage:moi3];
    CGImageRelease(moi3);

    self.iv.image = moi4;
    
#elif which == 2
    
    UIGraphicsBeginImageContextWithOptions(moiextent.size, NO, 0);
    [[UIImage imageWithCIImage:blend.outputImage] drawInRect:moiextent];
    UIImage* moi4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     
    self.iv.image = moi4;

#endif

}


@end
