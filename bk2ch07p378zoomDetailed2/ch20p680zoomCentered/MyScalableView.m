

#import "MyScalableView.h"

@interface MyScalableView ()
@property (strong, nonatomic) UIImage* currentImage;
@property (strong, nonatomic) NSValue* currentSize;
@end

@implementation MyScalableView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    self.backgroundColor = [UIColor blackColor];
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"rect %@", NSStringFromCGRect(rect));
    NSLog(@"bounds %@", NSStringFromCGRect(self.bounds));
    NSLog(@"contents scale %f", self.layer.contentsScale);
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"earthFromSaturn" ofType:@"png"];
    UIImage* im = [[UIImage alloc] initWithContentsOfFile:path];
    [im drawInRect:rect];
    

}

@end
