

#import "MyVignetteFilter.h"

@interface MyVignetteFilter ()
@property (nonatomic, strong) CIImage* inputImage;
@end

@implementation MyVignetteFilter

-(CIImage *)outputImage {
    
    CGRect inextent = self.inputImage.extent;
    
    CIFilter* grad = [CIFilter filterWithName:@"CIRadialGradient"];
    CIVector* center = [CIVector vectorWithX:inextent.size.width/2.0
                                           Y:inextent.size.height/2.0];
    [grad setValue:center forKey:@"inputCenter"];
    [grad setValue:@85 forKey:@"inputRadius0"];
    [grad setValue:@100 forKey:@"inputRadius1"];
    CIImage *gradimage = [grad valueForKey: @"outputImage"];
    
    CIFilter* blend = [CIFilter filterWithName:@"CIBlendWithMask"];
    [blend setValue:self.inputImage forKey:@"inputImage"];
    [blend setValue:gradimage forKey:@"inputMaskImage"];
    
    return blend.outputImage;

}

@end
