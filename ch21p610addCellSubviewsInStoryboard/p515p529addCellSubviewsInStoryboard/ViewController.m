

#import "ViewController.h"
#import "MyCell.h"

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
    
    // this next line is all we have to do to obtain a cell!
    // the prototype cell is pre-registered
    // if there's nothing in the reuse queue...
    // the storyboard retrieves the prototype cell and hands it to us as needed
    MyCell *cell = (MyCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    
    cell.theLabel.text = @"The author of this book, who would rather be out dirt biking";
    
    // ... set up iv here ...
    UIImage* im = [UIImage imageNamed:@"moi.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0.0);
    [im drawInRect:CGRectMake(0,0,36,36)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.theImageView.image = im2;
    
    return cell;
}



@end
