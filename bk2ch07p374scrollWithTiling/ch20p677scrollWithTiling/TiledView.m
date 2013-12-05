

#import "TiledView.h"

@interface TiledView()
@end

@implementation TiledView

+ (Class) layerClass {
    return [CATiledLayer class];
}

// not sure what this is supposed to do

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    [super setContentScaleFactor:1.f];
}


-(void)drawRect:(CGRect)r {
    
    NSLog(@"drawRect: %@", NSStringFromCGRect(r));
    
    CGRect tile = r;
    int x = tile.origin.x/TILESIZE;
    int y = tile.origin.y/TILESIZE;
    NSString *tileName = [NSString stringWithFormat:@"CuriousFrog_500_%d_%d", x+3, y];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:tileName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    [image drawAtPoint:CGPointMake(x*TILESIZE,y*TILESIZE)];
    
    // comment out the following! it's here just so we can see the tile boundaries
    
    UIBezierPath* bp = [UIBezierPath bezierPathWithRect: r];
    [[UIColor whiteColor] setStroke];
    [bp stroke];
    
}

@end
