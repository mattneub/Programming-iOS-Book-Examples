
#import "MyGradientBackView.h"
#import <QuartzCore/QuartzCore.h>

@interface GradientView:UIView
@end
@implementation GradientView
+(Class)layerClass {
    return [CAGradientLayer class];
}
@end


@implementation MyGradientBackView

- (void) awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor blackColor];
    UIView* v2 = [GradientView new];
    CAGradientLayer* lay = (CAGradientLayer*)v2.layer;
    lay.colors = @[(id)[UIColor colorWithWhite:0.6 alpha:1].CGColor,
    (id)([UIColor colorWithWhite:0.4 alpha:1].CGColor)];
    lay.borderWidth = 1;
    lay.borderColor = [UIColor blackColor].CGColor;
    lay.cornerRadius = 5;
    [self addSubview:v2];
    v2.frame = self.bounds;
    v2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    // or you could do the same thing with constraints, but there is no need
}

@end
