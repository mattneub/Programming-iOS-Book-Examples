

#import "MyMandelbrotOperation.h"


@implementation MyMandelbrotOperation  {
    CGSize size;
    CGPoint center;
    CGFloat zoom;
    CGContextRef bitmapContext;
}

- (id) initWithSize: (CGSize) sz center: (CGPoint) c zoom: (CGFloat) z {
    self = [super init];
    if (self) {
        self->size = sz;
        self->center = c;
        self->zoom = z;
    }
    return self;
}

- (void) dealloc {
    if (self->bitmapContext)
        CGContextRelease(self->bitmapContext);
}

- (CGContextRef) bitmapContext {
    return self->bitmapContext;
}

// create (and memory manage) instance variable
- (void) makeBitmapContext:(CGSize)sizze {
    if (self->bitmapContext)
        CGContextRelease(self->bitmapContext);
	int bitmapBytesPerRow = (sizze.width * 4);
	bitmapBytesPerRow += (16 - bitmapBytesPerRow%16)%16;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = NULL;
	context = CGBitmapContextCreate(NULL, sizze.width, sizze.height, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
    self->bitmapContext = context;
}

#define MANDELBROT_STEPS	200

// draw pixels of self->bitmapContext

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

- (void)drawAtCenter:(CGPoint)centerr zoom:(CGFloat)zoomm
{
	CGContextSetAllowsAntialiasing(bitmapContext, FALSE);
    CGContextSetRGBFillColor(bitmapContext, 0.0f, 0.0f, 0.0f, 1.0f);
	
	CGFloat re;
	CGFloat im;
	
    int maxi = self->size.width;
    int maxj = self->size.height;
	for (int i = 0; i < maxi; i++)
	{
		for (int j = 0; j < maxj; j++)
		{
			re = (((CGFloat)i - 1.33f * centerr.x)/160);	
			im = (((CGFloat)j - 1.00f * centerr.y)/160);	
			
			re /= zoomm;
			im /= zoomm;
			
			if (isInMandelbrotSet(re, im))
			{
				CGContextFillRect (bitmapContext, CGRectMake(i, j, 1.0f, 1.0f));
			}
		}
	}
}

- (void) main {
    if ([self isCancelled])
        return;
    [self makeBitmapContext: self->size];
    [self drawAtCenter: self->center zoom: self->zoom];
    if (![self isCancelled])
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"MyMandelbrotOperationFinished" object:self];
}


@end
