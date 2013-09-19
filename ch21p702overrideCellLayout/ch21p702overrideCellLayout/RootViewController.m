

#import "RootViewController.h"
#import "MyCell.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[MyCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell.textLabel.numberOfLines != 2) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 2;
    }

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
