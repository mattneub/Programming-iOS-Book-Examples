

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CompassLayer : CALayer {
}
@property (nonatomic, assign) CALayer* arrow;
- (void) rotateArrow;

@end
