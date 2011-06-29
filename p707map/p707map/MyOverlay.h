

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MyOverlay : NSObject <MKOverlay> {
    
}
@property (nonatomic, readonly) MKMapRect boundingMapRect;
- (id) initWithRect: (MKMapRect) rect;

@property (nonatomic, retain) UIBezierPath* path;

@end
