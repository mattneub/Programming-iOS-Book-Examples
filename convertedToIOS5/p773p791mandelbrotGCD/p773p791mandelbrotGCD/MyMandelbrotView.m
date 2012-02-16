//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone 

#import "MyMandelbrotView.h"

@interface MyMandelbrotView ()
- (void)drawAtCenter:(CGPoint)center zoom:(CGFloat)zoom context:(CGContextRef)c;
- (CGContextRef)makeBitmapContext:(CGSize)size CF_RETURNS_RETAINED; // quiet the Analyzer
@end

// best to run on device, because we want a slow processor in order to see the delay
// you can increase the size of MANDELBROT_STEPS to make even more of a delay
// but on my device, there's plenty of delay as is!

#define MANDELBROT_STEPS	200

@implementation MyMandelbrotView {
    CGContextRef bitmapContext;
    dispatch_queue_t draw_queue;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        self->draw_queue = dispatch_queue_create("com.neuburg.mandeldraw", NULL);
    }
    return self;
}

/*
- (void) drawThatPuppy {
    [self makeBitmapContext: self.bounds.size];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self drawAtCenter: center zoom: 1];
    [self setNeedsDisplay];
}
 */

- (void) drawThatPuppy {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // see p. 775; to test, increase MANDELBROT_STEPS and suspend while still calculating
    __block UIBackgroundTaskIdentifier bti = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler: 
     ^{
         [[UIApplication sharedApplication] endBackgroundTask:bti];
     }];
    if (bti == UIBackgroundTaskInvalid)
        return;
    dispatch_async(draw_queue, ^{ 
        CGContextRef bitmap = [self makeBitmapContext: self.bounds.size];
        [self drawAtCenter: center zoom: 1 context:bitmap];
        dispatch_async(dispatch_get_main_queue(), ^{ 
            if (self->bitmapContext)
                CGContextRelease(self->bitmapContext);
            self->bitmapContext = bitmap;
            [self setNeedsDisplay];
            [[UIApplication sharedApplication] endBackgroundTask:bti];
        });
    });
}

// ==== this material is called on background thread

// create (and return) context
- (CGContextRef) makeBitmapContext:(CGSize)size {
	int bitmapBytesPerRow = (size.width * 4);
	bitmapBytesPerRow += (16 - bitmapBytesPerRow%16)%16;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = NULL;
	context = CGBitmapContextCreate(NULL, size.width, size.height, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
    return context;
}

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

- (void)drawAtCenter:(CGPoint)center zoom:(CGFloat)zoom context: (CGContextRef) context
{
	CGContextSetAllowsAntialiasing(context, FALSE);
    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
	
	CGFloat re;
	CGFloat im;
	
    int maxi = self.bounds.size.width;
    int maxj = self.bounds.size.height;
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
				CGContextFillRect (context, CGRectMake(i, j, 1.0f, 1.0f));
			}
		}
	}
}

// ==== end of material called on background thread

// turn pixels of self->bitmapContext into CGImage, draw into ourselves
- (void) drawRect:(CGRect)rect {
    static BOOL which = NO;
    if (self->bitmapContext) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGImageRef im = CGBitmapContextCreateImage(self->bitmapContext);
        CGContextDrawImage(context, self.bounds, im);
        CGImageRelease(im);
        // this will make it more obvious when we are redrawn
        self.backgroundColor = (which = !which) ? [UIColor greenColor] : [UIColor redColor];
    }
}

// final memory managment

- (void) dealloc {
    if (bitmapContext)
        CGContextRelease(bitmapContext);
    dispatch_release(draw_queue);
}



@end
