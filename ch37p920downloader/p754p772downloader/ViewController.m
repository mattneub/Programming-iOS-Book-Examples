

#import "ViewController.h"
#import "MyImageDownloader.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray* model;
@end

@implementation ViewController
@synthesize model;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static BOOL added = NO;
    if (!added) {
        added = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloaded:) name:@"imageDownloaded" object:nil];
    }
    NSString* mannyurl = @"http://www.apeth.com/pep/manny.jpg";
    NSString* jackurl = @"http://www.apeth.com/pep/jack.jpg";
    NSString* moeurl = @"http://www.apeth.com/pep/moe.jpg";
    if (!self.model) {
        self.model = [NSMutableArray array];
        for (int ix = 0; ix < 5; ix++) {
            NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:mannyurl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            MyImageDownloader* idl = [[MyImageDownloader alloc] initWithRequest:req];
            NSDictionary* d = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Manny", @"text", idl, @"pic", nil];
            [self.model addObject: d];
        }
        for (int ix = 5; ix < 10; ix++) {
            NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:moeurl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            MyImageDownloader* idl = [[MyImageDownloader alloc] initWithRequest:req];
            NSDictionary* d = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Moe", @"text", idl, @"pic", nil];
            [self.model addObject: d];
        }
        for (int ix = 10; ix < 15; ix++) {
            NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:jackurl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            MyImageDownloader* idl = [[MyImageDownloader alloc] initWithRequest:req];
            NSDictionary* d = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Jack", @"text", idl, @"pic", nil];
            [self.model addObject: d];
        }
    }
}

- (void) imageDownloaded: (NSNotification*) n {
    MyImageDownloader* d = [n object];
    NSUInteger row = [self.model indexOfObjectPassingTest: 
                      ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                          return ([(NSDictionary*)obj objectForKey:@"pic"] == d);
                      }];
    if (row == NSNotFound) return; // shouldn't happen
    NSIndexPath* ip = [NSIndexPath indexPathForRow:row inSection:0];
    NSArray* ips = [self.tableView indexPathsForVisibleRows];
    if ([ips indexOfObject:ip] != NSNotFound) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: ip] 
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!model)
        return 0;
    return [model count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary* d = [self.model objectAtIndex: indexPath.row];
    cell.textLabel.text = [d objectForKey:@"text"];
    MyImageDownloader* imd = [d objectForKey:@"pic"];
    cell.imageView.image = imd.image;
    return cell;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
