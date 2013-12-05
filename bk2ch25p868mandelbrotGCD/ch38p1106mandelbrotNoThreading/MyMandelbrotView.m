//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone 

#import "MyMandelbrotView.h"

#define MANDELBROT_STEPS	200

@implementation MyMandelbrotView {
    CGContextRef _bitmapContext;
    dispatch_queue_t _draw_queue;
}

static char* QKEY = "label";
static char* QVAL = "com.neuburg.mandeldraw";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        self->_draw_queue = dispatch_queue_create(QVAL, nil);
        dispatch_queue_set_specific(self->_draw_queue, QKEY, QVAL, nil);
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
    // [self makeBitmapContext:CGSizeZero]; // test "wrong thread" assertion
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // to test, increase MANDELBROT_STEPS and suspend while still calculating
    __block UIBackgroundTaskIdentifier bti = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:
                                              ^{
                                                  [[UIApplication sharedApplication] endBackgroundTask:bti];
                                              }];
    if (bti == UIBackgroundTaskInvalid)
        return;
    dispatch_async(self->_draw_queue, ^{
        CGContextRef bitmap = [self makeBitmapContext: self.bounds.size];
        [self drawAtCenter: center zoom: 1 context:bitmap];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->_bitmapContext)
                CGContextRelease(self->_bitmapContext);
            self->_bitmapContext = bitmap;
            [self setNeedsDisplay];
            [[UIApplication sharedApplication] endBackgroundTask:bti];
        });
    });
}

// ==== this material is called on background thread

- (void) assertOnBackgroundThread {
    NSAssert(dispatch_get_specific(QKEY) == QVAL, @"Wrong thread");
}

// create (and return) context

- (CGContextRef) makeBitmapContext:(CGSize)size CF_RETURNS_RETAINED {
    [self assertOnBackgroundThread];
	int bitmapBytesPerRow = (size.width * 4);
	bitmapBytesPerRow += (16 - bitmapBytesPerRow%16)%16;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = nil;
	context = CGBitmapContextCreate(nil, size.width, size.height, 8, bitmapBytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
    return context;
}

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

- (void)drawAtCenter:(CGPoint)center zoom:(CGFloat)zoom context: (CGContextRef) context
{
    [self assertOnBackgroundThread];
    
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

// turn pixels of self->_bitmapContext into CGImage, draw into ourselves
- (void) drawRect:(CGRect)rect {
    static BOOL which = NO;
    if (self->_bitmapContext) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGImageRef im = CGBitmapContextCreateImage(self->_bitmapContext);
        CGContextDrawImage(context, self.bounds, im);
        CGImageRelease(im);
        // this will make it more obvious when we are redrawn
        self.backgroundColor = (which = !which) ? [UIColor greenColor] : [UIColor redColor];
    }
}

// final memory managment

- (void) dealloc {
    if (_bitmapContext)
        CGContextRelease(_bitmapContext);
    // dispatch_release(draw_queue);
    // on iOS 6 and later, dispatch_release not necessary and the compiler will flag it
    // this is a big change, actually; see <os/object.h>
}

@end
