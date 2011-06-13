
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

// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier] autorelease];
        CGFloat side = cell.contentView.bounds.size.height;
        UIImageView* iv = [[UIImageView alloc] init];
        iv.frame = 
        CGRectMake(cell.contentView.bounds.size.width - side, 0, side, side);
        iv.tag = 1;
        iv.autoresizingMask = UIViewAutoresizingFlexibleHeight | 
        UIViewAutoresizingFlexibleLeftMargin;
        [cell.contentView addSubview:iv];
        [iv release];
        UILabel* lab = [[UILabel alloc] init];
        lab.frame = 
        CGRectMake(5, 0, cell.contentView.bounds.size.width - side - 10, side);
        lab.tag = 2;
        lab.autoresizingMask = UIViewAutoresizingFlexibleHeight | 
        UIViewAutoresizingFlexibleRightMargin;
        [cell.contentView addSubview:lab];
        [lab release];
    }
    UILabel* lab = (UILabel*)[cell viewWithTag: 2];
    lab.text = @"The author of this book, who would rather be out dirt biking";
    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    lab.lineBreakMode = UILineBreakModeWordWrap;
    lab.numberOfLines = 2;
    lab.textColor = [UIColor whiteColor];
    // can now do this here, because framework won't change it later
    lab.backgroundColor = [UIColor clearColor];

    UIImageView* iv = (UIImageView*)[cell viewWithTag: 1];
    UIImage* im = [UIImage imageNamed:@"moi.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35,35), YES, 0.0);
    [im drawInRect:CGRectMake(0,0,35,35)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    iv.image = im2;
    iv.contentMode = UIViewContentModeCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView 
  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![cell.layer valueForKey:@"done"]) {
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
        [v release];
        [cell.layer setValue:@"done" forKey:@"done"];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
