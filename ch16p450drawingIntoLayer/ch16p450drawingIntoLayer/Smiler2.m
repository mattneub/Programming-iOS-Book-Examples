

#import "Smiler2.h"

@implementation Smiler2

-(void)displayLayer:(CALayer *)layer {
    layer.contents = (id)[UIImage imageNamed:@"smiley"].CGImage;
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%@", layer.contentsGravity);

}

@end
