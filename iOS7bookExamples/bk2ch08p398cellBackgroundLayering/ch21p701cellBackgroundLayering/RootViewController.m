

#import "RootViewController.h"



@interface RootViewController ()

@end

@implementation RootViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 20;
}

// window background is white
// table view background is green

/*
 the window background never appears
 the table view background appears when you "bounce" the scroll beyond its limits
 the red cell background color is behind the cell
 the linen cell background view is on top of that
 the (translucent, here) selected background view is on top of that
 the content view and its contents are on top of that
 */


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:CellIdentifier];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
        UIImageView* v = [UIImageView new]; // no need to set frame
        v.contentMode = UIViewContentModeScaleToFill;
        v.image = [UIImage imageNamed:@"linen.png"];
        cell.backgroundView = v;
        
        UIView* v2 = [UIView new]; // no need to set frame
        v2.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        cell.selectedBackgroundView = v2;
        // next line no longer necessary in iOS 7!
        // cell.textLabel.backgroundColor = [UIColor clearColor];
        
        // next line didn't work until iOS 7!
        cell.backgroundColor = [UIColor redColor];

        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Hello there! %ld", (long)indexPath.row];

    
    return cell;
}

// this trick no longer needed in iOS 7!
/*
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor redColor];
}
*/


@end
