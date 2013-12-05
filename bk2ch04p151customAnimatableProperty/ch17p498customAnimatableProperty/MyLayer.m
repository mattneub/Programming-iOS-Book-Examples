

#import "MyLayer.h"

@interface MyLayer ()
@property CGFloat thickness;
@end

@implementation MyLayer

@dynamic thickness;

+ (BOOL) needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString: @"thickness"])
        return YES;
    return [super needsDisplayForKey:key];
}


- (void) drawInContext:(CGContextRef)con {
    CGRect r = CGRectInset(self.bounds, 20, 20);
    CGContextSetFillColorWithColor(con, [UIColor redColor].CGColor);
    CGContextFillRect(con, r);
    CGContextSetLineWidth(con, self.thickness);
    CGContextStrokeRect(con, r);
}



@end
