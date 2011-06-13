

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RootViewController
@synthesize tvc;

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
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:self options:nil];
        cell = self.tvc;
    }
    UILabel* lab = (UILabel*)[cell viewWithTag: 2];
    // ... set up lab here ...
    // notice how much less of this there now is, because it's mostly done in the nib
    lab.text = @"The author of this book, who would rather be out dirt biking";
    
    UIImageView* iv = (UIImageView*)[cell viewWithTag: 1];
    // ... set up iv here ...
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
