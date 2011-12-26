
// new example
// showing the layering order of the background material behind a cell's contents

#import "RootViewController.h"

@implementation RootViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
        UIImageView* v = [[UIImageView alloc] initWithFrame:cell.bounds];
        v.contentMode = UIViewContentModeScaleToFill;
        v.image = [UIImage imageNamed:@"linen.png"];
        cell.backgroundView = v;
        UIView* v2 = [[UIView alloc] initWithFrame:cell.bounds];
        v2.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1];
        cell.selectedBackgroundView = v2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = @"Howdy there"; 
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor redColor];
}


@end
