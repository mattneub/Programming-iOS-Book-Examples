

#import <Foundation/Foundation.h>


@interface MyKnob : UIControl {
    CGFloat angle;
    CGFloat initialAngle;
    BOOL continuous;
}
@property (nonatomic) CGFloat angle;
@property (nonatomic) BOOL continuous;

@end
