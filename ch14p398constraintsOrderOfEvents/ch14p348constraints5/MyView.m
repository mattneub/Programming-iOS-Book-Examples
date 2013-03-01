#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyView

-(void)updateConstraints {
    [super updateConstraints];
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

-(void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

-(void)layoutSublayersOfLayerNOT:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

@end
