

#import "MyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated]; // note order of operations
    if (selected) {
        UIActivityIndicatorView* v = 
        [[UIActivityIndicatorView alloc] 
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        v.center = 
        CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        v.frame = CGRectIntegral(v.frame);
        v.color = [UIColor yellowColor];
        v.tag = 1001;
        [self.contentView addSubview:v];
        [v startAnimating];
    } else {
        [[self.contentView viewWithTag:1001] removeFromSuperview];
        // no harm if nonexistent
    }
}

@end
