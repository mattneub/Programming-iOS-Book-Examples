

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController {
    IBOutlet UIImageView *iv;
    CALayer* layer;
}

- (void) makeCopy {
    if (!layer) return;
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CGImageRef imref = (__bridge CGImageRef)layer.contents;
        UIImage* im = [UIImage imageWithCGImage:imref];
        NSLog(@"layer contents image size: %@", NSStringFromCGSize(im.size));
        
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, 0);
        [layer renderInContext:UIGraphicsGetCurrentContext()];
        iv.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
}

- (void) drawLayer: (CALayer*) lay inContext: (CGContextRef) con {
    NSLog(@"drawlayerincontext");
    // CGContextClearRect(con, lay.bounds);
    CGContextBeginTransparencyLayer(con, NULL);
    CGContextSetShadow(con, CGSizeMake(3,3), 12);
    CGContextSetFillColorWithColor(con, [UIColor blueColor].CGColor);
    CGContextFillEllipseInRect(con, CGRectMake(30,30,100,100));
    CGContextClearRect(con, CGRectMake(80,80,100,100));

    CGContextEndTransparencyLayer(con);

    self->layer = lay; // keep a pointer
    [self makeCopy];
}

- (IBAction)assignContents:(id)sender {
    [CATransaction setDisableActions:YES]; // explained in next chapter
    layer.contents = (id)[UIImage imageNamed:@"moi.jpg"].CGImage;
    [self makeCopy];
}

- (IBAction)redisplay:(id)sender {
    [layer setNeedsDisplay];
    // don't say makecopy, causes loop
}

- (IBAction)toggleOpaque:(id)sender {
    [CATransaction setDisableActions:YES]; // explained in next chapter
    layer.opaque = !layer.opaque;
    [layer setNeedsDisplay]; // otherwise we don't see the effect of the change
    //[self makeCopy];
}

- (IBAction)background:(id)sender {
    [CATransaction setDisableActions:YES]; // explained in next chapter
    CGColorRef clear = [UIColor clearColor].CGColor;
    CGColorRef red = [[UIColor redColor] colorWithAlphaComponent:0.99].CGColor;
    if (CGColorEqualToColor(layer.backgroundColor, clear) || nil == layer.backgroundColor)
        layer.backgroundColor = red;
    else
        layer.backgroundColor = clear;
    [self makeCopy];
}

- (IBAction)opacity:(id)sender {
    [CATransaction setDisableActions:YES]; // explained in next chapter
    if (layer.opacity < 0.5)
        layer.opacity = 1;
    else
        layer.opacity = 0.4;
    [self makeCopy];
}


@end
