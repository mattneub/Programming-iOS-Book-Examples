

#import "TiledView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TiledView

+ (Class) layerClass {
    return [CATiledLayer class];
}

-(void)drawRect:(CGRect)r {
    [[UIColor whiteColor] set];
    UIRectFill(self.bounds);
    [[UIColor blackColor] set];
    UIFont* f = [UIFont fontWithName:@"Helvetica" size:18];
    // height consists of 31 spacers with 30 texts between them
    CGFloat viewh = self.bounds.size.height;
    CGFloat spacerh = 10;
    CGFloat texth = (viewh - (31*spacerh))/30.0;
    CGFloat y = spacerh;
    for (int i = 0; i < 30; i++) {
        NSString* s = [NSString stringWithFormat:@"This is label %i", i];
        [s drawAtPoint:CGPointMake(10,y) withFont:f];
        y += texth + spacerh;
    }
    
    // uncomment the following: it's just so we can see the tiling
    UIBezierPath* bp = [UIBezierPath bezierPathWithRect:r];
    [[UIColor redColor] setStroke];
    [bp stroke];
}

@end
