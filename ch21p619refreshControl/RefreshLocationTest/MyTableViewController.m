

#import "MyTableViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

/*
 Example of a refresh control, imitating the look of Apple's Mail app.
 Notice that we must hook up the refresh control's action in code;
 doing it in the storyboard doesn't work.
 */

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(doRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"Howdy";
    
    return cell;
}

- (void) doRefresh: (UIRefreshControl*) sender {
    NSLog(@"%@", @"refreshing...");
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
}



@end
