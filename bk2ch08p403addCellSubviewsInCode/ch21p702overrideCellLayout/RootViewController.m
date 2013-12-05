

#import "RootViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (![cell viewWithTag:1]) {
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
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[lab]-15-[iv]-15-|"
                                                 options:0 metrics:nil views:d]];
        
        
        lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 2;

    }
    
    UILabel* lab = (UILabel*)[cell.contentView viewWithTag: 2];
    lab.text = @"The author of this book, who would rather be out dirt biking";
    
    UIImageView* iv = (UIImageView*)[cell.contentView viewWithTag: 1];
    // shrink apparent size of image
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
