
#import <Foundation/Foundation.h>


@interface MyMandelbrotOperation : NSOperation {
    CGSize size;
    CGPoint center;
    CGFloat zoom;
    CGContextRef bitmapContext;
}
- (id) initWithSize: (CGSize) sz center: (CGPoint) c zoom: (CGFloat) z;
- (CGContextRef) bitmapContext;
@end
