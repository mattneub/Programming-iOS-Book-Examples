#import "MyView.h"

@interface MyView ()
@property (nonatomic, copy) NSString* name;
@end

@implementation MyView

/*

-(NSString*) description {
    return [[super description] stringByAppendingFormat:@" %@", self.name];
}

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
 
 */

@end
