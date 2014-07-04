

#import "RootViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil]
         forCellReuseIdentifier:@"Cell"];
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
    
    UILabel* lab = (UILabel*)[cell.contentView viewWithTag: 2];
    lab.text = @"The author of this book, who would rather be out dirt biking";
    
    UIImageView* iv = (UIImageView*)[cell.contentView viewWithTag: 1];
    
    // missing constraint: make the image view a square (can't say that in the nib, alas)
    if (!iv.constraints.count) {
        [iv addConstraint:
         [NSLayoutConstraint
          constraintWithItem:iv attribute:NSLayoutAttributeWidth relatedBy:0 toItem:iv attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
    
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
