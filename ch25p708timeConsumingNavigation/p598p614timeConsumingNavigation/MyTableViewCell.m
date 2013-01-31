

#import "MyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MyTableViewCell ()

@end

@implementation MyTableViewCell

/*
 Converted to use constraints, but goodness this turned out to be a lot of work!
 Main problem is you must remember to remove constraints when you remove a subview.
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        UIActivityIndicatorView* v = 
        [[UIActivityIndicatorView alloc] 
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        v.color = [UIColor yellowColor];
        v.tag = 1001;
        [self.contentView addSubview:v];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [v.superview addConstraint:
         [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:v.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [v.superview addConstraint:
         [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:v.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        v.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [v startAnimating];
    } else {
        UIView* v = [self viewWithTag:1001];
        if (v) {
            for (NSLayoutConstraint* con in self.contentView.constraints) {
                if (con.firstItem == v)
                    [self.contentView removeConstraint:con];
            }
            [v removeFromSuperview];
        }
    }
    [super setSelected:selected animated:animated];
}

@end
