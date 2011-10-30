

#import "MyLayer.h"


@implementation MyLayer
@dynamic thickness;

+ (BOOL) needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString: @"thickness"])
        return YES;
    return [super needsDisplayForKey:key];
}


- (void) drawInContext:(CGContextRef)ctx {
    CGRect r = CGRectInset(self.bounds, 20, 20);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithWhite:.5 alpha:.5] CGColor]);
    CGContextFillRect(ctx, r);
    CGContextSetLineWidth(ctx, self.thickness);
    CGContextStrokeRect(ctx, r);
}



@end
