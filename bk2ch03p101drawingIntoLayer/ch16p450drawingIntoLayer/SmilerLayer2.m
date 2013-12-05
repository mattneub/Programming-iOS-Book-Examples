

#import "SmilerLayer2.h"

@implementation SmilerLayer2

-(void)display {
    self.contents = (id)[UIImage imageNamed:@"smiley"].CGImage;
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%@", self.contentsGravity);

}

@end
