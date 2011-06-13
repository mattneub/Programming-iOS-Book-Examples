
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyCell.h"

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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = @"The author of this book, who would rather be out dirt biking";
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // shrink apparent size of image
    UIImage* im = [UIImage imageNamed:@"moi.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35,35), YES, 0.0);
    [im drawInRect:CGRectMake(0,0,35,35)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.image = im2;
    cell.imageView.contentMode = UIViewContentModeCenter;
    
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
        cell.textLabel.backgroundColor = [UIColor clearColor];
        [cell.layer setValue:@"done" forKey:@"done"];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
