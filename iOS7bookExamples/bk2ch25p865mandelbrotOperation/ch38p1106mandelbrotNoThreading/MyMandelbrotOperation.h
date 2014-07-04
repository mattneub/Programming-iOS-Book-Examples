
#import <Foundation/Foundation.h>


@interface MyMandelbrotOperation : NSOperation
- (id) initWithSize: (CGSize) sz center: (CGPoint) c zoom: (CGFloat) z;
- (CGContextRef) bitmapContext;
@end
