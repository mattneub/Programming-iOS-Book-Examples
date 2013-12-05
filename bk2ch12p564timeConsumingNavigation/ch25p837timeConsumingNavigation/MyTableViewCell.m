

#import "MyTableViewCell.h"

@interface MyTableViewCell ()

@end

@implementation MyTableViewCell

// reverted to not using constraints on this one

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        UIActivityIndicatorView* v = 
        [[UIActivityIndicatorView alloc] 
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        v.color = [UIColor yellowColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            v.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
        });
        v.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
        v.layer.cornerRadius = 10;
        CGRect f = v.frame;
        f = CGRectInset(f, -10, -10);
        v.frame = f;
        CGRect cf = self.frame;
        cf = [self.contentView convertRect:cf fromView:self];
        v.center = CGPointMake(CGRectGetMidX(cf), CGRectGetMidY(cf));
        v.tag = 1001;
        [self.contentView addSubview:v];
        [v startAnimating];
    } else {
        UIView* v = [self viewWithTag:1001];
        if (v) {
            [v removeFromSuperview];
        }
    }
}

@end
