

#import "MySlider.h"


@implementation MySlider

- (void) awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:t];
    
    
//    self.superview.tintColor = [UIColor redColor];
//    self.minimumTrackTintColor = [UIColor yellowColor];
//    self.maximumTrackTintColor = [UIColor greenColor];
//    self.thumbTintColor = [UIColor orangeColor];
    [self setThumbImage:[UIImage imageNamed:@"moneybag1.png"] forState:UIControlStateNormal];
    UIImage* coin = [UIImage imageNamed: @"coin2.png"];
    UIImage* coinEnd = [coin resizableImageWithCapInsets:UIEdgeInsetsMake(0,7,0,7) resizingMode:UIImageResizingModeStretch];
    [self setMinimumTrackImage:coinEnd forState:UIControlStateNormal];
    [self setMaximumTrackImage:coinEnd forState:UIControlStateNormal];

//    CGRect f = self.bounds;
//    f.size.height += 30;
//    self.bounds = f;
}

-(CGSize)intrinsicContentSize {
    CGSize sz = [super intrinsicContentSize];
    sz.height += 30;
    return sz;
}

- (void) tapped: (UIGestureRecognizer*) g {
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: s];
    CGRect track = [s trackRectForBounds:s.bounds];
    if (!CGRectContainsPoint(CGRectInset(track, 0, -10), pt))
        return; // not on track, forget it
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES]; // animation broken in iOS 7
}


- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds {
    CGRect result = [super maximumValueImageRectForBounds:bounds];
    result = CGRectOffset(result, 31, 0);
    return result;
}

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds {
    CGRect result = [super minimumValueImageRectForBounds:bounds];
    result = CGRectOffset(result, -31, 0);
    return result;
}
- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect result = [super trackRectForBounds:bounds];
    result.origin.x = 0;
    result.size.width = bounds.size.width;
    return result;
}


- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    result = CGRectOffset(result, 0, -7);
    return result;
}

@end
