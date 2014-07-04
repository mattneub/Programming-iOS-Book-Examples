

#import "MyView.h"

@implementation MyView


-(void)layoutSubviews {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super layoutSubviews];
}

-(void)updateConstraints {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super updateConstraints];
}
 

@end
