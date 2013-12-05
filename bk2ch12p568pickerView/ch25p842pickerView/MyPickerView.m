
#import "MyPickerView.h"

@implementation MyPickerView

-(CGSize)intrinsicContentSize {
    NSLog(@"%@", @"here");
    CGSize sz = [super intrinsicContentSize];
    sz.height = 140; // but it only goes down to 162
    // sz.width = 250; // just proving this does *something*
    
    return sz;
}

@end
