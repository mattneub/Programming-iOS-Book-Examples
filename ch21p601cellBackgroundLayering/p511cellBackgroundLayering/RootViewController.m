
// showing the layering order of the background material behind a cell's contents

#import "RootViewController.h"

@implementation RootViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

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
 the red cell background color is behind the cell (must be set later)
 the linen cell background view is on top of that
 the (translucent, here) selected background view is on top of that
 the content view and its contents are on top of that
 */

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // okay, I need to say something about the modern dequeue system
    // in iOS 6, if you register a class beforehand,
    // dequeue works like the new dequeue...:forIndexPath: -
    // namely, it never returns nil
    // however, I'm going to switch exclusively to the forIndexPath: version
    // why? because it has one huge advantage: if you call it *without* registering beforehand,
    // it crashes with a nice log message
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // used to have a cell == nil test here
    // but with the modern dequeue system, the cell is never nil
    // so we need another way to know if we've initially configured this cell
    if (!cell.backgroundView) {
        UIImageView* v = [UIImageView new]; // no need to set frame
        v.contentMode = UIViewContentModeScaleToFill;
        v.image = [UIImage imageNamed:@"linen.png"];
        cell.backgroundView = v;
        UIView* v2 = [UIView new]; // no need to set frame
        v2.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1];
        cell.selectedBackgroundView = v2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = @"Howdy there";
    // next line doesn't work, have to do it later
    // cell.backgroundColor = [UIColor redColor];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor redColor];
}


@end
