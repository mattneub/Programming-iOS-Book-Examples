//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone 

#import "MyMandelbrotView.h"
#import "MyMandelbrotOperation.h"

@interface MyMandelbrotView()
@property (nonatomic, strong) NSOperationQueue* queue;
@end


@implementation MyMandelbrotView {
	CGContextRef _bitmapContext ;
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
    CGPoint center =
    CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    if (!self.queue) {
        NSOperationQueue* q = [NSOperationQueue new];
        [q setMaxConcurrentOperationCount:1];
        self.queue = q; // retain policy
    }
    MyMandelbrotOperation* op =
    [[MyMandelbrotOperation alloc] initWithSize:self.bounds.size
                                         center:center zoom:1];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(operationFinished:)
                                                 name:@"MyMandelbrotOperationFinished"
                                               object:op];
    [self.queue addOperation:op];
}

// ==== this material is now moved into an NSOperation
/*
 
 // create (and memory manage) instance variable
 - (void) makeBitmapContext:(CGSize)size {
 if (self->bitmapContext)
 CGContextRelease(self->bitmapContext);
 int bitmapBytesPerRow = (size.width * 4);
 bitmapBytesPerRow += (16 - bitmapBytesPerRow%16)%16;
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 CGContextRef context = nil;
 context = CGBitmapContextCreate(nil, size.width, size.height, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
 CGColorSpaceRelease(colorSpace);
 self->bitmapContext = context;
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
 
 - (void)drawAtCenter:(CGPoint)center zoom:(CGFloat)zoom
 {
 CGContextSetAllowsAntialiasing(bitmapContext, FALSE);
 CGContextSetRGBFillColor(bitmapContext, 0.0f, 0.0f, 0.0f, 1.0f);
 
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
 CGContextFillRect (bitmapContext, CGRectMake(i, j, 1.0f, 1.0f));
 }
 }
 }
 }
 */

// ==== end of material moved to NSOperation

// warning! called on background thread
- (void) operationFinished: (NSNotification*) n {
    [self performSelectorOnMainThread:@selector(redrawWithOperation:)
                           withObject:[n object] waitUntilDone:NO];
}

// now we're back on the main thread
- (void) redrawWithOperation: (MyMandelbrotOperation*) op {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"MyMandelbrotOperationFinished"
     object:op];
    CGContextRef context = [op bitmapContext];
    if (self->_bitmapContext)
        CGContextRelease(self->_bitmapContext);
    self->_bitmapContext = (CGContextRef) context;
    CGContextRetain(self->_bitmapContext);
    [self setNeedsDisplay];
}

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
    if (self->_bitmapContext)
        CGContextRelease(self->_bitmapContext);
    [self->_queue cancelAllOperations];
}



@end
