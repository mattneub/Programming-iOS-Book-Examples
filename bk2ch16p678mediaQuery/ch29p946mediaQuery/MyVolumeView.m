

#import "MyVolumeView.h"

@implementation MyVolumeView

// uncomment to test

-(CGRect)volumeSliderRectForBounds:(CGRect)bounds {
    // NSLog(@"%@", NSStringFromCGRect(bounds));
    return [super volumeSliderRectForBounds:bounds];
}

-(CGRect)volumeThumbRectForBounds:(CGRect)bounds volumeSliderRect:(CGRect)rect value:(float)value {
    // NSLog(@"%f", value);
    return [super volumeThumbRectForBounds:bounds volumeSliderRect:rect value:value];
}

@end
