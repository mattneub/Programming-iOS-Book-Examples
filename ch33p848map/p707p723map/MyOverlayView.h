
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyOverlayView : MKOverlayView;
- (id) initWithOverlay:(id <MKOverlay>)overlay angle: (CGFloat) angle;
@end
