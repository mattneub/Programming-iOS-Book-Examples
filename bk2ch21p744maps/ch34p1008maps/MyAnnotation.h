

#import <Foundation/Foundation.h>
@import MapKit;

@interface MyAnnotation : NSObject <MKAnnotation> 

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title, *subtitle;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;


@end
