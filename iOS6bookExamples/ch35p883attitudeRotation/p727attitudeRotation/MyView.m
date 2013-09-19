

#import "MyView.h"

@implementation MyView {
    CALayer* layer1;
    CALayer* layer2a;
    CALayer* layer2b;
}

+ (Class)layerClass {
    return [CATransformLayer class];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        CALayer* lay = [CALayer new];
        lay.frame = self.bounds;
        //lay.backgroundColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:lay];
        self->layer1 = lay;
        lay = [CALayer new];
        lay.frame = CGRectInset(self.bounds, 30,30);
        lay.backgroundColor = [UIColor greenColor].CGColor;
        lay.shadowOffset = CGSizeMake(8,8);
        lay.shadowRadius = 12;
        lay.shadowColor = [UIColor grayColor].CGColor;
        lay.shadowOpacity = 0.8;
        lay.zPosition = -10;
        [self->layer1 addSublayer:lay];
        self->layer2a = lay;
        lay = [CALayer new];
        lay.frame = CGRectOffset(self->layer2a.bounds, 40, 40);
        lay.backgroundColor = [UIColor yellowColor].CGColor;
        lay.shadowOffset = CGSizeMake(8,8);
        lay.shadowRadius = 12;
        lay.shadowColor = [UIColor grayColor].CGColor;
        lay.shadowOpacity = 0.8;
        lay.zPosition = 30;
        [self->layer1 addSublayer:lay];
        self->layer2b = lay;
        lay.contents = (id)[UIImage imageNamed:@"jet.png"].CGImage;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
