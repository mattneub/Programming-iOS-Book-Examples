
#import "RootViewController.h"
#import "MyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Start";
    return;
    
    // just playing
    UIActivityIndicatorView* v = 
    [[UIActivityIndicatorView alloc] 
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    v.center = 
    CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    v.frame = CGRectIntegral(v.frame);
    v.color = [UIColor yellowColor];
    v.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    v.layer.cornerRadius = 10;
    v.tag = 1001;
    [self.view addSubview:v];
    [v startAnimating];

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
