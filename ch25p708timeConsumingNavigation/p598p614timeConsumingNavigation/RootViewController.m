
#import "RootViewController.h"
#import "MyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Start";

}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"Let's go";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gogogo:) userInfo:nil repeats:NO];
}

- (void) gogogo: (id) dummy {
    UIViewController *detailViewController = [[UIViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
