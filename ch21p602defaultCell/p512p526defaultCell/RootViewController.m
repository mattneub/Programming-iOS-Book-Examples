

#import "RootViewController.h"
#import "MyCell.h"
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
        switch (which) {
            case 1:
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                              reuseIdentifier:CellIdentifier]; // no autorelease
                break;
            case 2:
                cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:CellIdentifier]; // no autorelease
                break;
        }
        
        // stuff that is in common for all cells can go here
        // no need to do this in willDisplayCell
        // (not sure when that got fixed, probably iOS 4; 
        // but anyhow I'm now ignoring pre-iOS 4.2 systems and their quirks)
        
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
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        // comment out next line to see hole punch problem
        // I'm ignoring pre-iOS 4...
        // ...so we can now keep this line here rather than postponing to willDisplayCell
        cell.textLabel.backgroundColor = [UIColor clearColor];
        

    }

    // stuff that is different for each cell goes here
    // okay, in this case it's all the same! but bear with me, it's just an example
    // point is we *could* have a different text and image for each row
    
    cell.textLabel.text = @"The author of this book, who would rather be out dirt biking";

    // shrink apparent size of image
    UIImage* im = [UIImage imageNamed:@"moi.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0.0);
    [im drawInRect:CGRectMake(0,0,36,36)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.image = im2;
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    return cell;
}


@end
