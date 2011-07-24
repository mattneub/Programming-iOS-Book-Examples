

#import <UIKit/UIKit.h>

@interface MyMandelbrotView : UIView {
    CGContextRef bitmapContext;
    dispatch_queue_t draw_queue;
}
- (void)drawAtCenter:(CGPoint)center zoom:(CGFloat)zoom context:(CGContextRef)c;
- (CGContextRef)makeBitmapContext:(CGSize)size;
- (void) drawThatPuppy;
@end
