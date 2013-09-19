

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GradientView:UIView
@end
@implementation GradientView
+(Class)layerClass {
    return [CAGradientLayer class];
}
@end

@implementation RootViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

#define which 1 // try 2 for cell layout override in cell class

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    if (cell.backgroundView == nil) {
        // stuff that is in common for all cells can go here
        
        UIView* v = [UIView new];
        v.backgroundColor = [UIColor blackColor];
        UIView* v2 = [GradientView new];
        CAGradientLayer* lay = (CAGradientLayer*)v2.layer;
        lay.colors = @[(id)[UIColor colorWithWhite:0.6 alpha:1].CGColor,
        (id)([UIColor colorWithWhite:0.4 alpha:1].CGColor)];
        lay.borderWidth = 1;
        lay.borderColor = [UIColor blackColor].CGColor;
        lay.cornerRadius = 5;
        [v addSubview:v2];
        v2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // or you could do the same thing with constraints, but there is no need
        cell.backgroundView = v;
        
        // insert our own views into the contentView
        
        // CGFloat side = cell.contentView.bounds.size.height;
        UIImageView* iv = [UIImageView new];
        iv.tag = 1;
        [cell.contentView addSubview:iv];

        UILabel* lab = [UILabel new];
        lab.tag = 2;
        [cell.contentView addSubview:lab];
        
        // since we are now adding the views ourselves (not reusing the default views),
        // we can use autolayout to lay them out
        
        NSDictionary* d = NSDictionaryOfVariableBindings(iv, lab);
        iv.translatesAutoresizingMaskIntoConstraints = NO;
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        // image view is vertically centered
        [cell.contentView addConstraint:
         [NSLayoutConstraint
          constraintWithItem:iv attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        // it's a square
        [cell.contentView addConstraint:
         [NSLayoutConstraint
          constraintWithItem:iv attribute:NSLayoutAttributeWidth relatedBy:0 toItem:iv attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];        
        // label has height pinned to superview
        [cell.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lab]|"
                                                 options:0 metrics:nil views:d]];
        // horizontal margins
        [cell.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[lab]-10-[iv]-5-|"
                                                 options:0 metrics:nil views:d]];

    }
    
    // stuff that is different for each cell goes here
    // okay, in this case it's all the same! but bear with me, it's just an example
    // point is we *could* have a different text and image for each row
    
    UILabel* lab = (UILabel*)[cell.contentView viewWithTag: 2];

    lab.text = @"The author of this book, who would rather be out dirt biking";
    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    lab.lineBreakMode = NSLineBreakByWordWrapping; // UILineBreakModeWordWrap deprecated
    lab.numberOfLines = 2;
    lab.textColor = [UIColor whiteColor];
    lab.backgroundColor = [UIColor clearColor];

    // shrink apparent size of image
    UIImageView* iv = (UIImageView*)[cell.contentView viewWithTag: 1];
    
    UIImage* im = [UIImage imageNamed:@"moi.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0.0);
    [im drawInRect:CGRectMake(0,0,36,36)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    iv.image = im2;
    iv.contentMode = UIViewContentModeCenter;
    
    return cell;
}


@end
