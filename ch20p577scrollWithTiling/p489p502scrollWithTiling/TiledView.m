

#import "TiledView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TiledView

+ (Class) layerClass {
    return [CATiledLayer class];
}

-(void)drawRect:(CGRect)r {
    CGRect tile = r;
    int x = tile.origin.x/TILESIZE;
    int y = tile.origin.y/TILESIZE;
    NSString *tileName = [NSString stringWithFormat:@"Shed_1000_%i_%i", x, y];
    NSString *path = [[NSBundle mainBundle] pathForResource:tileName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [image drawAtPoint:tile.origin];
    
    // comment out the following! it's here just so we can see the tile boundaries
    
    UIBezierPath* bp = [UIBezierPath bezierPathWithRect: r];
    [[UIColor whiteColor] setStroke];
    [bp stroke];
}


@end
