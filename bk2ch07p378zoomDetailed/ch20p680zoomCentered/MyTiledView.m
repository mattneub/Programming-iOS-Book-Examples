

#import "MyTiledView.h"

@interface MyTiledView ()
@property (strong, nonatomic) UIImage* currentImage;
@property (strong, nonatomic) NSValue* currentSize;
@end

@implementation MyTiledView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    CATiledLayer* lay = (CATiledLayer*)self.layer;
    CGFloat scale = lay.contentsScale;
    lay.tileSize = CGSizeMake(208*scale,238*scale);
    lay.levelsOfDetail = 3;
    lay.levelsOfDetailBias = 2;
    self->_currentSize = [NSValue valueWithCGSize:CGSizeZero];
    return self;
}

+ (Class) layerClass {
    return [CATiledLayer class];
}

- (void)drawRect:(CGRect)rect
{
//    NSLog(@"rect %@", NSStringFromCGRect(rect));
//    NSLog(@"bounds %@", NSStringFromCGRect(self.bounds));
//    NSLog(@"contents scale %f", self.layer.contentsScale);
//    NSLog(@"%@", NSStringFromCGAffineTransform(CGContextGetCTM(UIGraphicsGetCurrentContext())));
//    NSLog(@"%@", NSStringFromCGRect(CGContextGetClipBoundingBox(UIGraphicsGetCurrentContext())));
    
          
    CGSize oldSize = self.currentSize.CGSizeValue;
    if (!CGSizeEqualToSize(oldSize, rect.size)) {
        // make a new size
        self.currentSize = [NSValue valueWithCGSize:rect.size];
        // make a new image
        CATiledLayer* lay = (CATiledLayer*) self.layer;
        
        CGAffineTransform tr = CGContextGetCTM(UIGraphicsGetCurrentContext());
        CGFloat sc = tr.a/lay.contentsScale;
        CGFloat scale = sc/4.0;
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"earthFromSaturn" ofType:@"png"];
        UIImage* im = [[UIImage alloc] initWithContentsOfFile:path];
        CGSize sz = CGSizeMake(im.size.width * scale, im.size.height * scale);
        UIGraphicsBeginImageContextWithOptions(sz, YES, 1);
        [im drawInRect:CGRectMake(0,0,sz.width,sz.height)];
        self.currentImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"created image at size %@", NSStringFromCGSize(sz));
    }
    [self.currentImage drawInRect:self.bounds];
    
    // comment out the following! it's here just so we can see the tile boundaries
    
    UIBezierPath* bp = [UIBezierPath bezierPathWithRect: rect];
    [[UIColor whiteColor] setStroke];
    [bp stroke];

}

@end
