

#import "MyView.h"

@implementation MyView

-(void) drawRect:(CGRect)rect {
    NSLog(@"v (%i): draw", self.tag);
}

-(void)layoutSubviews {
    NSLog(@"v (%i): layout", self.tag);
    [super layoutSubviews];
}

-(void)updateConstraints {
    NSLog(@"v (%i): update", self.tag);
    [super updateConstraints];
}

@end
