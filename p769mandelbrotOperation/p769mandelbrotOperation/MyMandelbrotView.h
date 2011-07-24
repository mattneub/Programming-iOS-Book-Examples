

#import <UIKit/UIKit.h>

@interface MyMandelbrotView : UIView
{
	CGContextRef bitmapContext ;
}

@property (nonatomic, retain) NSOperationQueue* queue;

//- (void)drawAtCenter:(CGPoint)center zoom:(CGFloat)zoom ;
//- (void)makeBitmapContext:(CGSize)size ;
- (void) drawThatPuppy;

@end
