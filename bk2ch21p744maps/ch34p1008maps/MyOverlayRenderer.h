
#import <Foundation/Foundation.h>
@import MapKit;

@interface MyOverlayRenderer : MKOverlayRenderer;
- (id) initWithOverlay:(id <MKOverlay>)overlay angle: (CGFloat) angle;
@end
