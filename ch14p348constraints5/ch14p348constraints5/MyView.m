#import "MyView.h"

@implementation MyView

-(void)updateConstraints {
    [super updateConstraints];
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

-(void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

@end
