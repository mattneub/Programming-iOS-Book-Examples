

#import "MyView.h"

@implementation MyView

-(void)awakeFromNib {
    // uncomment and try again
    // self.exclusiveTouch = YES;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%p", self);
}

@end
