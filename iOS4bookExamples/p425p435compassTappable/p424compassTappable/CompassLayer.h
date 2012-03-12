

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CompassLayer : CALayer {
}
@property (nonatomic, assign) CALayer* theArrow;
- (void) rotateArrow;

@end
