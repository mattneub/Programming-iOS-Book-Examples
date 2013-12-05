

#import "MyMandelbrotOperation.h"


@implementation MyMandelbrotOperation  {
    CGSize _size;
    CGPoint _center;
    CGFloat _zoom;
    CGContextRef _bitmapContext;
}

- (id) initWithSize: (CGSize) sz center: (CGPoint) c zoom: (CGFloat) z {
    self = [super init];
    if (self) {
        self->_size = sz;
        self->_center = c;
        self->_zoom = z;
    }
    return self;
}

- (void) dealloc {
    if (self->_bitmapContext)
        CGContextRelease(self->_bitmapContext);
}

- (CGContextRef) bitmapContext {
    return self->_bitmapContext;
}

// create (and memory manage) instance variable
- (void) makeBitmapContext:(CGSize)size {
    if (self->_bitmapContext)
        CGContextRelease(self->_bitmapContext);
	int bitmapBytesPerRow = (size.width * 4);
	bitmapBytesPerRow += (16 - bitmapBytesPerRow%16)%16;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = nil;
	context = CGBitmapContextCreate(nil, size.width, size.height, 8, bitmapBytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
    self->_bitmapContext = context;
}

#define MANDELBROT_STEPS	200

// draw pixels of self->_bitmapContext

BOOL isInMandelbrotSet(float re, float im)
{
	float x = 0;	float nx;
	float y = 0;	float ny;
	bool fl = TRUE;
	for(int i = 0; i < MANDELBROT_STEPS; i++)
	{
		nx = x*x - y*y + re;
		ny = 2*x*y + im;
		if((nx*nx + ny*ny) > 4)
		{
			fl = FALSE;
			break;
		}
		x = nx;
		y = ny;
	}
	return fl;
}

- (void)drawAtCenter:(CGPoint)center zoom:(CGFloat)zoom
{
	CGContextSetAllowsAntialiasing(self->_bitmapContext, FALSE);
    CGContextSetRGBFillColor(self->_bitmapContext, 0.0f, 0.0f, 0.0f, 1.0f);
	
	CGFloat re;
	CGFloat im;
	
    int maxi = self->_size.width;
    int maxj = self->_size.height;
	for (int i = 0; i < maxi; i++)
	{
		for (int j = 0; j < maxj; j++)
		{
			re = (((CGFloat)i - 1.33f * center.x)/160);	
			im = (((CGFloat)j - 1.00f * center.y)/160);	
			
			re /= zoom;
			im /= zoom;
			
			if (isInMandelbrotSet(re, im))
			{
				CGContextFillRect (self->_bitmapContext, CGRectMake(i, j, 1.0f, 1.0f));
			}
		}
	}
}

- (void) main {
    if ([self isCancelled])
        return;
    [self makeBitmapContext: self->_size];
    [self drawAtCenter: self->_center zoom: self->_zoom];
    if (![self isCancelled])
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"MyMandelbrotOperationFinished" object:self];
}


@end
