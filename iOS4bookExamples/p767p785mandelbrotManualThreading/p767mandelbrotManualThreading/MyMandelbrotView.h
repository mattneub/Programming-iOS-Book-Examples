

#import <UIKit/UIKit.h>

@interface MyMandelbrotView : UIView
{
	CGContextRef bitmapContext ;
}

- (void)drawAtCenter:(CGPoint)center zoom:(CGFloat)zoom ;
- (void)makeBitmapContext:(CGSize)size ;
- (void) drawThatPuppy;

@end
