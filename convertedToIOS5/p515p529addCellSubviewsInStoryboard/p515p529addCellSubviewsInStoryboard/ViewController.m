

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    // this next line is all we have to do to obtain a cell!
    // the prototype cell is pre-registered
    // if there's nothing in the reuse queue...
    // the storyboard retrieves the prototype cell and hands it to us as needed
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell.backgroundView) {
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
    }
    
    UILabel* lab = (UILabel*)[cell viewWithTag: 2];
    // ... set up lab here ...
    // notice how much less of this there now is, because it's mostly done in the nib
    lab.text = @"The author of this book, who would rather be out dirt biking";
    
    UIImageView* iv = (UIImageView*)[cell viewWithTag: 1];
    // ... set up iv here ...
    UIImage* im = [UIImage imageNamed:@"moi.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0.0);
    [im drawInRect:CGRectMake(0,0,36,36)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    iv.image = im2;
    
    return cell;
}



@end
