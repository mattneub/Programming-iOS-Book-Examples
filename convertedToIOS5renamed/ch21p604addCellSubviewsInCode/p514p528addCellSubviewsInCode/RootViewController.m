

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RootViewController


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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier]; // no autorelease
        
        // stuff that is in common for all cells can go here
        
        UIView* v = [[UIView alloc] initWithFrame:cell.frame];
        v.backgroundColor = [UIColor blackColor];
        CAGradientLayer* lay = [CAGradientLayer layer];
        lay.colors = [NSArray arrayWithObjects: 
                      (id)[UIColor colorWithWhite:0.6 alpha:1].CGColor, 
                      [UIColor colorWithWhite:0.4 alpha:1].CGColor, nil];
        lay.frame = v.layer.bounds;
        [v.layer addSublayer:lay];
        lay.borderWidth = 1;
        lay.borderColor = [UIColor blackColor].CGColor;
        lay.cornerRadius = 5;
        cell.backgroundView = v;
        
        CGFloat side = cell.contentView.bounds.size.height;
        UIImageView* iv = [[UIImageView alloc] init];
        iv.frame = CGRectMake(cell.contentView.bounds.size.width - side, 0, side, side);
        iv.tag = 1;
        iv.autoresizingMask = (UIViewAutoresizingFlexibleHeight | 
                               UIViewAutoresizingFlexibleLeftMargin);
        [cell.contentView addSubview:iv];

        UILabel* lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(5, 0, cell.contentView.bounds.size.width - side - 10, side);
        lab.tag = 2;
        lab.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                                UIViewAutoresizingFlexibleRightMargin);
        [cell.contentView addSubview:lab];
        
        
        
    }
    
    // stuff that is different for each cell goes here
    // okay, in this case it's all the same! but bear with me, it's just an example
    // point is we *could* have a different text and image for each row
    
    UILabel* lab = (UILabel*)[cell.contentView viewWithTag: 2];

    lab.text = @"The author of this book, who would rather be out dirt biking";
    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    lab.lineBreakMode = UILineBreakModeWordWrap;
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
